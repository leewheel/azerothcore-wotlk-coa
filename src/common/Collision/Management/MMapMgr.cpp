/*
 * This file is part of the AzerothCore Project. See AUTHORS file for Copyright information
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "MMapMgr.h"
#include "Config.h"
#include "Errors.h"
#include "Log.h"
#include "MapDefines.h"

namespace MMAP
{
    // ######################## MMapMgr ########################
    std::shared_ptr<dtNavMesh> MMapMgr::LoadNavMesh(uint32 mapId)
    {
        // load and init dtNavMesh - read parameters from file
        std::string fileName = Acore::StringFormat(MAP_FILE_NAME_FORMAT, sConfigMgr->GetOption<std::string>("DataDir", "."), mapId);

        FILE* file = fopen(fileName.c_str(), "rb");
        if (!file)
        {
            LOG_DEBUG("maps", "MMAP:loadMapData: Error: Could not open mmap file '{}'", fileName);
            return nullptr;
        }

        dtNavMeshParams params;
        uint32 count = uint32(fread(&params, sizeof(dtNavMeshParams), 1, file));
        fclose(file);
        if (count != 1)
        {
            LOG_DEBUG("maps", "MMAP:loadMapData: Error: Could not read params from file '{}'", fileName);
            return nullptr;
        }

        dtNavMesh* mesh = dtAllocNavMesh();
        ASSERT(mesh);
        if (DT_SUCCESS != mesh->init(&params))
        {
            dtFreeNavMesh(mesh);
            LOG_ERROR("maps", "MMAP:loadMapData: Failed to initialize dtNavMesh for mmap {:03} from file {}", mapId, fileName);
            return nullptr;
        }

        LOG_DEBUG("maps", "MMAP:loadMapData: Loaded {:03}.mmap", mapId);

        std::shared_ptr<dtNavMesh> navMesh = std::shared_ptr<dtNavMesh>(mesh, NavMeshDeleter());
        return navMesh;
    }

    uint32 MMapMgr::packTileID(int32 x, int32 y)
    {
        return uint32(x << 16 | y);
    }

    bool MMapMgr::LoadTile(dtNavMesh* navMesh, uint32 mapId, int32 x, int32 y)
    {
        // load this tile :: mmaps/MMMXXYY.mmtile
        std::string fileName = Acore::StringFormat(TILE_FILE_NAME_FORMAT, sConfigMgr->GetOption<std::string>("DataDir", "."), mapId, x, y);
        FILE* file = fopen(fileName.c_str(), "rb");
        if (!file)
        {
            LOG_DEBUG("maps", "MMAP:loadMap: Could not open mmtile file '{}'", fileName);
            return false;
        }

        // read header
        MmapTileHeader fileHeader;
        if (fread(&fileHeader, sizeof(MmapTileHeader), 1, file) != 1 || fileHeader.mmapMagic != MMAP_MAGIC)
        {
            LOG_ERROR("maps", "MMAP:loadMap: Bad header in mmap {:03}{:02}{:02}.mmtile", mapId, x, y);
            fclose(file);
            return false;
        }

        if (fileHeader.mmapVersion != MMAP_VERSION)
        {
            LOG_ERROR("maps", "MMAP:loadMap: {:03}{:02}{:02}.mmtile was built with generator v{}, expected v{}",
                           mapId, x, y, fileHeader.mmapVersion, MMAP_VERSION);
            fclose(file);
            return false;
        }

        unsigned char* data = (unsigned char*)dtAlloc(fileHeader.size, DT_ALLOC_PERM);
        ASSERT(data);

        std::size_t result = fread(data, fileHeader.size, 1, file);
        if (!result)
        {
            LOG_ERROR("maps", "MMAP:loadMap: Bad header or data in mmap {:03}{:02}{:02}.mmtile", mapId, x, y);
            fclose(file);
            return false;
        }

        fclose(file);

        dtTileRef tileRef = 0;

        //By leewheel 2026年11月10日 幂等保护：同一个网格瓦片被重复请求加载时（并发进出同一格、
        //  或上一次 addTile 后瓦片尚未卸载），detour 会因该网格坐标已被占用而返回 DT_ALREADY_OCCUPIED，
        //  核心随即打印 "Could not load ... into navmesh" 错误，误导玩家以为是数据损坏。
        //  这里先用瓦片自带的网格坐标查一次，已加载就直接视为成功，避免误报与重复占用。
        dtMeshHeader const* tileHeader = reinterpret_cast<dtMeshHeader const*>(data);
        if (navMesh->getTileAt(tileHeader->x, tileHeader->y, tileHeader->layer))
        {
            dtFree(data);
            LOG_DEBUG("maps", "MMAP:loadMap: Tile {:03}[{:02},{:02}] layer {} already loaded, skipped", mapId,
                      tileHeader->x, tileHeader->y, tileHeader->layer);
            return true;
        }

        // memory allocated for data is now managed by detour, and will be deallocated when the tile is removed
        dtStatus addStatus = navMesh->addTile(data, fileHeader.size, DT_TILE_FREE_DATA, 0, &tileRef);
        if (dtStatusSucceed(addStatus))
        {
            dtMeshHeader* header = (dtMeshHeader*)data;
            LOG_DEBUG("maps", "MMAP:loadMap: Loaded mmtile {:03}[{:02},{:02}] into {:03}[{:02},{:02}]", mapId, x, y, mapId, header->x, header->y);
            return true;
        }

        //By leewheel 2026年11月10日 失败时打印 detour 状态位，便于判断是内存、版本还是占用问题
        LOG_ERROR("maps", "MMAP:loadMap: Could not load {:03}{:02}{:02}.mmtile into navmesh (dtStatus {:#010x}, tileGrid [{:02},{:02}] layer {}, bytes {})",
                  mapId, x, y, uint32(addStatus), tileHeader->x, tileHeader->y, tileHeader->layer, fileHeader.size);
        dtFree(data);
        return false;
    }
    //End By leewheel

    ManagedNavMeshQuery MMapMgr::CreateNavMeshQuery(dtNavMesh* navMesh)
    {
        // allocate mesh query
        dtNavMeshQuery* query = dtAllocNavMeshQuery();
        ASSERT(query);

        if (dtStatusFailed(query->init(navMesh, 1024)))
        {
            dtFreeNavMeshQuery(query);
            return nullptr;
        }

        ManagedNavMeshQuery navMeshQuery = ManagedNavMeshQuery(query);
        return navMeshQuery;
    }
}
