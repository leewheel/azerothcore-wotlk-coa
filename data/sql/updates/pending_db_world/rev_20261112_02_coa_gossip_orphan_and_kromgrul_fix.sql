-- 修复 rev_20261110_96 删除双天赋对话后遗留的悬空条件行（213 条），以及 Krom'Grul 喊话目标错位
-- By leewheel 2026年11月12日
-- 背景：rev_20261110_96 用 DELETE FROM gossip_menu_option WHERE OptionType IN (18,20) 删掉双天赋选项，
--       但 conditions 里 SourceTypeOrReferenceId=15（对话）的旧行没删，核心加载时逐条报
--       addToGossipMenuItems / Not handled grouped condition，213 条条件刷出 426 行错误日志。
-- 处理：把已经不存在对应对话选项的对话条件行清掉（只清悬空行，有选项的条件一律不动）。

DELETE c FROM `conditions` c
LEFT JOIN `gossip_menu_option` o ON o.`MenuID` = c.`SourceGroup` AND o.`OptionID` = c.`SourceEntry`
WHERE c.`SourceTypeOrReferenceId` = 15 AND o.`MenuID` IS NULL;

-- Krom'Grul（8977）的 On Aggro 喊话把目标写成了 ACTION_INVOKER（7），实际没有 invoker，
-- 运行时解析到 Testament of Hope（50250）并对它喊 creature_text 组 0，但该生物没有台词，
-- 于是每次进战斗都刷一条 SMART_ACTION_TALK 错误。改回对自己喊（1 = SMART_TARGET_SELF）。

UPDATE `smart_scripts`
SET `target_type` = 1
WHERE `entryorguid` = 8977 AND `source_type` = 0 AND `id` = 0 AND `action_type` = 1 AND `target_type` = 7;

-- End By leewheel
