-- mod-coa-prestige: player-facing hardcoded English moved into the module
-- string system so feedback follows the client locale. English lives in
-- `module_string`, zhCN translation in `module_string_locale`.
-- By leewheel 2026年10月27日

-- mod-coa-prestige: player-facing hardcoded English moved to module_string (zhCN added). By leewheel 2026-10-27
DELETE FROM `module_string` WHERE `module` = 'mod-coa-prestige';
DELETE FROM `module_string_locale` WHERE `module` = 'mod-coa-prestige';

INSERT IGNORE INTO `module_string` (`module`, `id`, `string`) VALUES
('mod-coa-prestige', 1, 'Chromie cannot find where your journey began.'),
('mod-coa-prestige', 2, 'Chromie\'s magic faltered and your prestige could not be saved. Contact a game master.'),
('mod-coa-prestige', 3, 'Chromie winds back time. Prestige {}: reach level {} again to unlock your specialization.'),
('mod-coa-prestige', 4, 'Your equipped gear and any overflow Prestige rewards were sent to your mailbox.'),
('mod-coa-prestige', 5, 'Prestige {} complete: your specialization is unlocked.');

INSERT IGNORE INTO `module_string_locale` (`module`, `id`, `locale`, `string`) VALUES
('mod-coa-prestige', 1, 'zhCN', '克罗米找不到你旅程开始的地方。'),
('mod-coa-prestige', 2, 'zhCN', '克罗米的魔法失控了，你的威望未能保存。请联系游戏管理员。'),
('mod-coa-prestige', 3, 'zhCN', '克罗米回溯了时间。威望{}：将等级练回{}即可解锁你的专精。'),
('mod-coa-prestige', 4, 'zhCN', '你身上的装备和多余的威望奖励已寄送到你的邮箱。'),
('mod-coa-prestige', 5, 'zhCN', '威望 {} 已完成：你的专精已解锁。');
