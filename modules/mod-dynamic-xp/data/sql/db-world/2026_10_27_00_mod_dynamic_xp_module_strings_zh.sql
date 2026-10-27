-- mod-dynamic-xp: player-facing hardcoded English moved into the module
-- string system so feedback follows the client locale. English lives in
-- `module_string`, zhCN translation in `module_string_locale`.
-- By leewheel 2026年10月27日

-- mod-dynamic-xp: player-facing hardcoded English moved to module_string (zhCN added). By leewheel 2026-10-27
DELETE FROM `module_string` WHERE `module` = 'mod-dynamic-xp';
DELETE FROM `module_string_locale` WHERE `module` = 'mod-dynamic-xp';

INSERT IGNORE INTO `module_string` (`module`, `id`, `string`) VALUES
('mod-dynamic-xp', 1, 'This server is running a |cff4CFF00{}|r XP rate. Type |cff4CFF00.xp|r to change your own.'),
('mod-dynamic-xp', 2, 'Choosing your own XP rate is turned off on this realm; ask a game master.'),
('mod-dynamic-xp', 3, 'Your XP rate is now |cff4CFF00{}|r, saved for this character.'),
('mod-dynamic-xp', 4, 'Your XP rate now follows the realm: |cff4CFF00{}|r.'),
('mod-dynamic-xp', 5, 'Your XP rate: |cff4CFF00{}|r ({}).'),
('mod-dynamic-xp', 6, 'The realm rate is {}. |cff4CFF00.xp default|r follows it again.'),
('mod-dynamic-xp', 7, 'Pick yours with {}.'),
('mod-dynamic-xp', 8, 'The realm rate is back to |cff4CFF00x1|r: no bonus is applied.'),
('mod-dynamic-xp', 9, 'The realm rate is now |cff4CFF00{}|r.'),
('mod-dynamic-xp', 10, 'Saved to {}. Characters with their own choice keep it.'),
('mod-dynamic-xp', 11, 'Could not write {}; the change lasts until the next restart.'),
('mod-dynamic-xp', 12, 'Realm XP rate: |cff4CFF00{}|r (the default for every character without its own choice).'),
('mod-dynamic-xp', 13, 'Change it with {}.'),
('mod-dynamic-xp', 14, 'your own choice'),
('mod-dynamic-xp', 15, 'the realm rate');

INSERT IGNORE INTO `module_string_locale` (`module`, `id`, `locale`, `string`) VALUES
('mod-dynamic-xp', 1, 'zhCN', '本服务器当前经验倍率为 |cff4CFF00{}|r。输入 |cff4CFF00.xp|r 可自行调整。'),
('mod-dynamic-xp', 2, 'zhCN', '本服务器已关闭自选经验倍率，请联系游戏管理员。'),
('mod-dynamic-xp', 3, 'zhCN', '你的经验倍率已设为 |cff4CFF00{}|r，并对该角色保存。'),
('mod-dynamic-xp', 4, 'zhCN', '你的经验倍率现在跟随服务器设置：|cff4CFF00{}|r。'),
('mod-dynamic-xp', 5, 'zhCN', '你的经验倍率：|cff4CFF00{}|r（{}）。'),
('mod-dynamic-xp', 6, 'zhCN', '服务器倍率为 {}。输入 |cff4CFF00.xp default|r 可重新跟随。'),
('mod-dynamic-xp', 7, 'zhCN', '用 {} 自选倍率。'),
('mod-dynamic-xp', 8, 'zhCN', '服务器倍率已恢复为 |cff4CFF00x1|r：无经验加成。'),
('mod-dynamic-xp', 9, 'zhCN', '服务器倍率已设为 |cff4CFF00{}|r。'),
('mod-dynamic-xp', 10, 'zhCN', '已保存到 {}。已自选倍率的角色不受影响。'),
('mod-dynamic-xp', 11, 'zhCN', '无法写入 {}；本次更改将在重启后失效。'),
('mod-dynamic-xp', 12, 'zhCN', '服务器经验倍率：|cff4CFF00{}|r（未自选角色的默认倍率）。'),
('mod-dynamic-xp', 13, 'zhCN', '用 {} 修改服务器倍率。'),
('mod-dynamic-xp', 14, 'zhCN', '你自己的选择'),
('mod-dynamic-xp', 15, 'zhCN', '服务器倍率');
