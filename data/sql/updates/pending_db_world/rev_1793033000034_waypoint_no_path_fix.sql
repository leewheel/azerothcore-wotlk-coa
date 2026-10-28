-- 修复 27 个 MovementType=2 (WAYPOINT) 但无 waypoint 路径的刷点。
-- 根因: creature_template_movement 迁移后, creature.MovementType=2 的老刷点若没有
-- creature_addon.path_id, 网格加载时 WaypointMovementGenerator::DoInitialize 会以
-- path id 0 查路径失败并 LOG_ERROR "doesn't have waypoint path id: 0"
-- (r3 门禁实弹: 82897 Eye of Dar'Khan, GUID Low 752)。
-- 修法: 脚本/SAI 驱动的 26 个刷点回落 IDLE (当前行为本就是报错后站桩, 脚本显式
-- MoveWaypoint 不受影响); 82897 Eye of Dar'Khan 改为 RANDOM+10 码游荡, 与同模板
-- 多数刷点 (82821/82825/82828 等 MovementType=1 wander 10) 风格一致。
-- #By leewheel 2026年10月28日

-- ① 脚本驱动刷点回落 IDLE (26 行)
UPDATE `creature` SET `MovementType` = 0 WHERE `guid` IN (
    42575,   -- 12339 Demetria (SmartAI 护送)
    43480,   -- 30830 Underking Talonox (SmartAI)
    43481,   -- 30830 Underking Talonox (SmartAI)
    63913,   -- 2258 Stone Fury (SmartAI)
    74169,   -- 21118 Razak Ironsides (护送脚本)
    75654,   -- 21657 Neltharaku (SmartAI 护送)
    77879,   -- 22215 Treebole (任务 NPC)
    83135,   -- 15663 War Effort Volunteer (事件 NPC)
    83136,   -- 15663 War Effort Volunteer
    83137,   -- 15663 War Effort Volunteer
    83138,   -- 15663 War Effort Volunteer
    83139,   -- 15663 War Effort Volunteer
    83140,   -- 15701 Field Marshal Snowfall (事件 NPC)
    83163,   -- 15696 War Effort Recruit (事件 NPC)
    83164,   -- 15696 War Effort Recruit
    83165,   -- 15696 War Effort Recruit
    83166,   -- 15696 War Effort Recruit
    84011,   -- 18672 Thomas Yance (护送脚本)
    86626,   -- 10825 Gish the Unmoving (SmartAI)
    128577,  -- 28500 Master Siegesmith Corvus (SmartAI)
    137611,  -- 33186 Razorscale (boss_razorscale 显式 MoveWaypoint)
    151089,  -- 16807 Grand Warlock Nethekurse (boss 脚本显式 MoveWaypoint)
    153321,  -- 14695 Lord Blackwood (SmartAI)
    201253,  -- 36880 Decaying Colossus (SmartAI)
    207210,  -- 37533 Rimefang (npc_rimefang_icc 显式 MoveWaypoint)
    207211   -- 37534 Spinestalker (npc_spinestalker 显式 MoveWaypoint)
);

-- ② Eye of Dar'Khan 82897 改 RANDOM 游荡 10 码 (同模板多数刷点风格)
UPDATE `creature` SET `MovementType` = 1, `wander_distance` = 10 WHERE `guid` = 82897;
