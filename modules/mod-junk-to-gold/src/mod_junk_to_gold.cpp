#include "Chat.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "Item.h"
#include "ObjectMgr.h"
#include "DBCStores.h"
#include "Config.h"
#include "mod_junk_to_gold_config.h"

// By leewheel 2026-08-02
// 延迟销毁队列需要容器头文件
#include <vector>
#include <utility>
// End By leewheel


// By leewheel 2026-07-30
// 修复主线程卡顿：原实现在 OnPlayerLootItem 钩子内对 item_template_locale 做同步
// WorldDatabase.Query，拾取发生在地图更新线程，每个未缓存物品都会阻塞等待 MySQL 往返，
// 500+ 机器人满世界拾取灰色物品时造成世界线程周期性尖峰。
// AC 核心启动时已通过 ObjectMgr::LoadItemLocales 把 item_template_locale 全量加载进内存，
// 这里改用 sObjectMgr->GetItemLocale 纯内存查询，彻底移除运行期数据库访问与自建缓存。
static std::string GetLocalizedItemName(Player* player, ItemTemplate const* proto)
{
    if (!player || !proto)
        return "";

    int localeIndex = player->GetSession()->GetSessionDbLocaleIndex();
    if (localeIndex >= 0)
    {
        if (ItemLocale const* itemLocale = sObjectMgr->GetItemLocale(proto->ItemId))
        {
            std::string localizedName;
            ObjectMgr::GetLocaleString(itemLocale->Name, localeIndex, localizedName);
            if (!localizedName.empty())
                return localizedName;
        }
    }

    // locale 未命中或 enUS：官方默认名就在 item_template
    return proto->Name1;
}
// End By leewheel

static std::string BuildItemLink(Player* player, Item* item)
{
    ItemTemplate const* proto = item->GetTemplate();
    if (!proto)
        return "";

    uint32 color = ItemQualityColors[proto->Quality];
    std::string itemName = GetLocalizedItemName(player, proto);

    return Acore::StringFormat(
        "|c{:08x}|Hitem:{}::::::::{}:::::|h[{}]|h|r",
        color,
        proto->ItemId,
        player->GetLevel(),
        itemName
    );
}

// JunkToGold 新版本，物品自动显示客户端语言相同名称
class JunkToGold : public PlayerScript
{
public:
    JunkToGold() : PlayerScript("JunkToGold") {}

    void OnPlayerLootItem(Player* player, Item* item, uint32 count, ObjectGuid /*lootguid*/) override
    {
        // 检查模块是否启用
        if (!junk_Enable)
            return;

        if (!player || !item)
            return;

        ItemTemplate const* proto = item->GetTemplate();
        if (!proto)
            return;

        // 仅处理灰色物品
        if (proto->Quality != ITEM_QUALITY_POOR)
            return;

        // 卖价为 0 的灰色不处理
        if (proto->SellPrice == 0)
            return;

        SendTransactionInformation(player, item, count);

        // 给钱
        player->ModifyMoney(proto->SellPrice * count);

        // By leewheel 2026-08-02
        // 根治 use-after-free：原实现在 OnPlayerLootItem 钩子链内直接 DestroyItem 销毁灰色物品。
        // 拾取刚创建的物品是 ITEM_NEW 状态，Item::SetState(ITEM_REMOVED) 会立即 delete this，
        // 导致排在后面的 RandomEnchants/transmog/transmorpher 钩子拿到悬垂指针，
        // 在 item->GetTemplate() -> Object::GetUInt32Value 处访问 m_uint32Values=0 崩溃（C0000005）。
        // 修复：钩子链内绝不销毁物品，只记录待销毁信息，延迟到 OnPlayerAfterUpdate 统一处理。
        _pendingJunk.emplace_back(player->GetGUID(), item->GetGUID());
        // End By leewheel
    }

    // By leewheel 2026-08-02
    // 延迟销毁：玩家每 tick 更新时处理其待销毁灰色物品队列。
    // 延迟期间物品可能被玩家移动/装备/出售，一律重新校验后才销毁，防止误删。
    void OnPlayerAfterUpdate(Player* player, uint32 /*p_time*/) override
    {
        if (_pendingJunk.empty() || !player)
            return;

        ObjectGuid const& playerGuid = player->GetGUID();
        for (auto it = _pendingJunk.begin(); it != _pendingJunk.end();)
        {
            if (it->first != playerGuid)
            {
                ++it;
                continue;
            }

            Item* pItem = player->GetItemByGuid(it->second);
            // By leewheel 2026年10月28日 - COA 核心（AzerothCore 主线）Item 没有 HasValues()，
            //   等价的存活判断是 IsInWorld()（物品销毁后 m_inWorld 置 false），语义一致
            if (pItem && pItem->IsInWorld())
            {
                // 只销毁仍在背包中的灰色物品；玩家已装备或已转移的不处理
                if (!pItem->IsEquipped() && pItem->GetBagSlot() != NULL_BAG && pItem->GetSlot() != NULL_SLOT)
                {
                    if (ItemTemplate const* proto = pItem->GetTemplate())
                    {
                        if (proto->Quality == ITEM_QUALITY_POOR && proto->SellPrice != 0)
                        {
                            player->DestroyItem(pItem->GetBagSlot(), pItem->GetSlot(), true);
                        }
                    }
                }
            }

            it = _pendingJunk.erase(it);
        }
    }

    // By leewheel 2026-08-02
    // 玩家下线时清理其未处理的待销毁记录，避免队列残留与幽灵数据
    void OnPlayerLogout(Player* player) override
    {
        if (_pendingJunk.empty() || !player)
            return;

        ObjectGuid const& playerGuid = player->GetGUID();
        for (auto it = _pendingJunk.begin(); it != _pendingJunk.end();)
        {
            if (it->first == playerGuid)
                it = _pendingJunk.erase(it);
            else
                ++it;
        }
    }
    // End By leewheel

private:
    // By leewheel 2026-08-02
    // 待销毁灰色物品队列：(玩家GUID, 物品GUID)，在 OnPlayerAfterUpdate 中延迟销毁
    std::vector<std::pair<ObjectGuid, ObjectGuid>> _pendingJunk;
    // End By leewheel

    void SendTransactionInformation(Player* player, Item* item, uint32 count)
    {
        // 官方 ItemLink（自动语言 / 颜色 / suffix / level）
        std::string name = BuildItemLink(player, item);

        if (count > 1)
            name += Acore::StringFormat("x{}", count);

        uint32 money = item->GetTemplate()->SellPrice * count;

        uint32 gold = money / GOLD;
        uint32 silver = (money % GOLD) / SILVER;
        uint32 copper = (money % SILVER);

        std::string info;

        if (money < SILVER)
        {
            info = Acore::StringFormat("{} 已出售，获得 {} 铜币。", name, copper);
        }
        else if (money < GOLD)
        {
            if (copper)
                info = Acore::StringFormat("{} 已出售，获得 {} 银币和 {} 铜币。", name, silver, copper);
            else
                info = Acore::StringFormat("{} 已出售，获得 {} 银币。", name, silver);
        }
        else
        {
            if (silver && copper)
                info = Acore::StringFormat("{} 已出售，获得 {} 金币、{} 银币和 {} 铜币。", name, gold, silver, copper);
            else if (silver)
                info = Acore::StringFormat("{} 已出售，获得 {} 金币和 {} 银币。", name, gold, silver);
            else if (copper)
                info = Acore::StringFormat("{} 已出售，获得 {} 金币和 {} 铜币。", name, gold, copper);
            else
                info = Acore::StringFormat("{} 已出售，获得 {} 金币。", name, gold);
        }

        ChatHandler(player->GetSession()).SendSysMessage(info);
    }
};

void Addmod_junk_to_goldScripts()
{
    // 加载配置
    LoadJunkToGoldConfig();

    //LoadFakePrefixIds();
    new JunkToGold();
}
