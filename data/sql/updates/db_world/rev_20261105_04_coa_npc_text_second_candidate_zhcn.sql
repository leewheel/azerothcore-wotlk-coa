-- NPC 对话（gossip 卷轴正文）中文修复。
-- 服务端在 QueryHandler.cpp 的 HandleQueryNPCText 里把同一槽位的两条候选文本
-- （npc_text.text0_0 与 text0_1）连同 Probability 一起发给客户端，由客户端二选一。
-- npc_text_locale 只给 Text0_0 写了中文、Text0_1 留空，客户端选中 Text0_1 时就显示主表英文。
-- 这里把已有的 zhCN Text0_0 同步到 Text0_1，两条候选都是中文。条件要求 Text0_1 为空，重复执行是空操作。
-- By leewheel 2026年11月05日
UPDATE `npc_text_locale` AS `l`
JOIN `npc_text` AS `n` ON `n`.`ID` = `l`.`ID`
SET `l`.`Text0_1` = `l`.`Text0_0`
WHERE `l`.`Locale` = 'zhCN'
  AND `n`.`text0_1` IS NOT NULL AND `n`.`text0_1` <> ''
  AND (`l`.`Text0_1` IS NULL OR `l`.`Text0_1` = '')
  AND `l`.`Text0_0` IS NOT NULL AND `l`.`Text0_0` <> '';
-- End By leewheel
