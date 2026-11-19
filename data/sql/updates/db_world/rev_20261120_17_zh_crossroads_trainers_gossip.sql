-- 2026.11.20 十字路口训练师对话选项汉化（鲁娜 9010710、沃尔提克斯 9010711）
-- 上游 rev_20261120_05 / 06 新增的 gossip 选项只有英文 "Train me."，补 zhCN。// By leewheel 20261120
DELETE FROM `gossip_menu_option_locale` WHERE `Locale` = 'zhCN' AND `MenuID` IN (9010710, 9010711);
INSERT INTO `gossip_menu_option_locale` (`MenuID`, `OptionID`, `Locale`, `OptionText`) VALUES
(9010710, 0, 'zhCN', '请训练我。'),
(9010711, 0, 'zhCN', '请训练我。');
