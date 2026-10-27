-- mod-coa-challenges: append ids 190-193 (Adventure Mode feedback) to the
-- module string system. Append only - never renumber existing ids.
-- English in `module_string`, zhCN in `module_string_locale`.
-- By leewheel 2026年10月27日

-- mod-coa-challenges: player-facing hardcoded English moved to module_string (zhCN added). By leewheel 2026-10-27
INSERT IGNORE INTO `module_string` (`module`, `id`, `string`) VALUES
('mod-coa-challenges', 190, 'Adventure Mode cannot change during combat, an encounter, death, flight, control or teleportation. Your party and pets must also be out of combat.'),
('mod-coa-challenges', 191, 'Choose a lower Adventure Mode level, at least 1.'),
('mod-coa-challenges', 192, 'Cannot lower a custom trial or select an Adventure Mode level already completed.'),
('mod-coa-challenges', 193, 'Adventure Mode reduced to level {}. Difficulty and rewards now use this level.');

INSERT IGNORE INTO `module_string_locale` (`module`, `id`, `locale`, `string`) VALUES
('mod-coa-challenges', 190, 'zhCN', '冒险模式在战斗、首领战、死亡、飞行、被控制或传送期间无法更改。你的队伍和宠物也必须脱离战斗。'),
('mod-coa-challenges', 191, 'zhCN', '请选择更低的冒险模式等级，至少为1级。'),
('mod-coa-challenges', 192, 'zhCN', '无法降低自定义试炼等级，也无法选择已完成的冒险模式等级。'),
('mod-coa-challenges', 193, 'zhCN', '冒险模式已降至等级{}。难度与奖励将按此等级计算。');
