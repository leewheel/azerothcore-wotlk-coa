-- mod-spellbook: player-facing hardcoded English moved into the module
-- string system so feedback follows the client locale. English lives in
-- `module_string`, zhCN translation in `module_string_locale`.
-- By leewheel 2026年10月27日

-- mod-spellbook: player-facing hardcoded English moved to module_string (zhCN added). By leewheel 2026-10-27
DELETE FROM `module_string` WHERE `module` = 'mod-spellbook';
DELETE FROM `module_string_locale` WHERE `module` = 'mod-spellbook';

INSERT IGNORE INTO `module_string` (`module`, `id`, `string`) VALUES
('mod-spellbook', 1, 'The book taught you {} ability or rank(s).'),
('mod-spellbook', 2, 'You already know everything this book can teach you.');

INSERT IGNORE INTO `module_string_locale` (`module`, `id`, `locale`, `string`) VALUES
('mod-spellbook', 1, 'zhCN', '这本书教会了你 {} 个技能或技能等级。'),
('mod-spellbook', 2, 'zhCN', '这本书能教的你都已经学会了。');
