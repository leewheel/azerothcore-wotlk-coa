-- 上游 2026-11-06 合并新增的飞行管理员口哨弹窗文本（npc_text 9990158）补简体中文。
-- By leewheel 2026年11月07日
INSERT INTO `npc_text_locale` (`ID`, `Locale`, `Text0_0`) VALUES
(9990158, 'zhCN', '从下面最近的 3 位飞行管理员中选择一位，传送到该地点。')
ON DUPLICATE KEY UPDATE `Text0_0` = VALUES(`Text0_0`);
-- End By leewheel
