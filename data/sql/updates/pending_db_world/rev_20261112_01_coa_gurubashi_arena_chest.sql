-- By leewheel 2026年11月12日
-- 荆棘谷竞技场宝箱（179697 Arena Treasure Chest / 竞技场财宝箱）改为按现实时间刷新，离线也计时。
--
-- 原机制（review 结论）：
--   game_event 16「Gurubashi Arena Booty Run」每 180 分钟触发一次（occurence=180，绝对时间循环），
--   事件开始时 NPC 14508（Short John Mithril，矮人约翰·秘银，常驻竞技场边）的 SAI 启动走位（path 14508），
--   走到 WP19 才在竞技场中心召唤宝箱，宝箱 10740 秒（约 179 分钟）后自动消失。
--   「离线不算时间」的两个根因：
--   1) 事件开始那一刻竞技场网格没有玩家加载时，SAI / 寻路完全冻结，
--      NPC 不走位、宝箱不召唤 → 离线期间的每一轮全部丢失；
--   2) SAI 召唤的宝箱 m_spawnedByDefault = false，被拿走后走
--      m_respawnTime = 0 的分支（GameObject.cpp 的 GO_JUST_DEACTIVATED），
--      直接消失且永不重生；召唤物也不持久化，服务器重启同样丢失。
--
-- 新机制：
--   给宝箱一条固定 spawn（本文件第 1 部分），spawntimesecs = 10800（3 小时）。
--   固定 spawn（m_spawnedByDefault = true）被拿走后走
--   m_respawnTime = now + 10800 的绝对时间戳路径，网格卸载时 SaveRespawnTime
--   持久化到 acore_characters.gameobject_respawn，离线多少天、服务器重启都不丢，
--   到期后有人靠近（网格加载）即出现，无人时也可以被远程查看。
--   同时停掉 SAI 里 WP19 的召唤动作（第 2 部分），保留矮人约翰的喊话走位演出，避免双宝箱。
--
-- 效果：宝箱一直在场直到被拿走；被拿走后按现实时间 3 小时重生，与玩家是否在线无关。

-- 1) 固定刷怪点：荆棘谷竞技场中心（坐标与朝向取自原 SAI 召唤参数）
DELETE FROM `gameobject` WHERE `id` = 179697;
INSERT INTO `gameobject`
(`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `ScriptName`, `VerifiedBuild`, `Comment`)
VALUES
(12101019, 179697, 0, 0, 0, 1, 1, -13202.9, 276.757, 21.8571, 2.77507, 0, 0, 0.98324, 0.18221, 10800, 100, 1, '', NULL, 'Gurubashi Arena Treasure Chest：固定刷怪点，被拿走后现实时间 3 小时重生（离线也计时）');

-- 2) 停掉 SAI 里「走到 WP19 召唤宝箱」的动作（id=3），矮人约翰的走位喊话演出保留
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 14508 AND `id` = 3;

-- End By leewheel
