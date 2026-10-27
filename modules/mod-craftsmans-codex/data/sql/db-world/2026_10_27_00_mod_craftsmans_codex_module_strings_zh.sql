-- mod-craftsmans-codex: player-facing hardcoded English moved into the module
-- string system so feedback follows the client locale. English lives in
-- `module_string`, zhCN translation in `module_string_locale`.
-- By leewheel 2026年10月27日

-- mod-craftsmans-codex: player-facing hardcoded English moved to module_string (zhCN added). By leewheel 2026-10-27
DELETE FROM `module_string` WHERE `module` = 'mod-craftsmans-codex';
DELETE FROM `module_string_locale` WHERE `module` = 'mod-craftsmans-codex';

INSERT IGNORE INTO `module_string` (`module`, `id`, `string`) VALUES
('mod-craftsmans-codex', 1, '|cffffd100Craftsman\'s Codex|r: a new |cff40ff40primary profession slot|r is unlocked.'),
('mod-craftsmans-codex', 2, '|cffffd100New profession slot|r |cff40ff40unlocked|r'),
('mod-craftsmans-codex', 3, 'No character by that name.'),
('mod-craftsmans-codex', 4, 'Name a character: .codex status <name>'),
('mod-craftsmans-codex', 5, 'Craftsman\'s Codex - {} (guid {}):'),
('mod-craftsmans-codex', 6, '  codex slots unlocked: {}'),
('mod-craftsmans-codex', 7, '  allowance: {} primary professions ({} base + {} unlocked)'),
('mod-craftsmans-codex', 8, '  professions held: {}, still free: {}, ceiling: {}'),
('mod-craftsmans-codex', 9, '  (offline; the held/free counts are what they will be on their next login)'),
('mod-craftsmans-codex', 10, '{} now has {} unlocked slot(s): {} primary professions in total.'),
('mod-craftsmans-codex', 11, '{} is back to {} primary profession(s).');

INSERT IGNORE INTO `module_string_locale` (`module`, `id`, `locale`, `string`) VALUES
('mod-craftsmans-codex', 1, 'zhCN', '|cffffd100工匠手册|r：新的 |cff40ff40主专业栏位|r 已解锁。'),
('mod-craftsmans-codex', 2, 'zhCN', '|cffffd100新的专业栏位|r |cff40ff40已解锁|r'),
('mod-craftsmans-codex', 3, 'zhCN', '没有找到该名字的角色。'),
('mod-craftsmans-codex', 4, 'zhCN', '请输入角色名：.codex status <角色名>'),
('mod-craftsmans-codex', 5, 'zhCN', '工匠手册 - {}（guid {}）：'),
('mod-craftsmans-codex', 6, 'zhCN', '  已解锁栏位：{}'),
('mod-craftsmans-codex', 7, 'zhCN', '  上限：{} 个主专业（{} 基础 + {} 解锁）'),
('mod-craftsmans-codex', 8, 'zhCN', '  已学专业：{}，剩余空位：{}，上限：{}'),
('mod-craftsmans-codex', 9, 'zhCN', '  （角色离线；此处显示的数字为下次登录时的数值）'),
('mod-craftsmans-codex', 10, 'zhCN', '{} 现已解锁 {} 个栏位：共 {} 个主专业。'),
('mod-craftsmans-codex', 11, 'zhCN', '{} 已恢复为 {} 个主专业。');
