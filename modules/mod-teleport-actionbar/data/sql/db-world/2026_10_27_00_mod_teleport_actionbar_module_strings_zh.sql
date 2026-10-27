-- mod-teleport-actionbar: player-facing hardcoded English moved into the module
-- string system so feedback follows the client locale. English lives in
-- `module_string`, zhCN translation in `module_string_locale`.
-- By leewheel 2026年10月27日

-- mod-teleport-actionbar: player-facing hardcoded English moved to module_string (zhCN added). By leewheel 2026-10-27
DELETE FROM `module_string` WHERE `module` = 'mod-teleport-actionbar';
DELETE FROM `module_string_locale` WHERE `module` = 'mod-teleport-actionbar';

INSERT IGNORE INTO `module_string` (`module`, `id`, `string`) VALUES
('mod-teleport-actionbar', 1, 'Stone of Retreat: {} is a {} stone - your {} character cannot use it.'),
('mod-teleport-actionbar', 2, 'Teleport tokens: placed {} button(s).'),
('mod-teleport-actionbar', 3, 'Teleport token data is not loaded.'),
('mod-teleport-actionbar', 4, 'Teleport tokens: learned {} spell(s), placed {} button(s).'),
('mod-teleport-actionbar', 5, 'Stones you know: {} for your faction, {} shared, {} of the other faction{}.');

INSERT IGNORE INTO `module_string_locale` (`module`, `id`, `locale`, `string`) VALUES
('mod-teleport-actionbar', 1, 'zhCN', '回城石：{} 是{}传送石——你的{}角色无法使用它。'),
('mod-teleport-actionbar', 2, 'zhCN', '传送令：已放置 {} 个按钮。'),
('mod-teleport-actionbar', 3, 'zhCN', '传送令数据尚未加载。'),
('mod-teleport-actionbar', 4, 'zhCN', '传送令：已学会 {} 个法术，放置了 {} 个按钮。'),
('mod-teleport-actionbar', 5, 'zhCN', '你已知晓的传送石：本阵营 {} 个，共享 {} 个，对方阵营 {} 个{}。');
