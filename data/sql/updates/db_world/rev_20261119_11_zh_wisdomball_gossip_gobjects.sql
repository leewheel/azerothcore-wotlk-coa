-- 2026.11.19 智慧球对话选项与物件名汉化（gossip_menu_option + gameobject_template）
-- By leewheel 20261119
DELETE FROM `gossip_menu_option_locale` WHERE `Locale` = 'zhCN' AND `MenuID` BETWEEN 9417000 AND 9417999;
INSERT INTO `gossip_menu_option_locale` (`MenuID`, `OptionID`, `Locale`, `OptionText`) VALUES
(9417001, 0, 'zhCN', '打开通往卡拉赞的传送门。'),
(9417002, 0, 'zhCN', '打开通往达拉然火山口的传送门。'),
(9417002, 1, 'zhCN', '送我回暴风城。'),
(9417002, 2, 'zhCN', '送我回奥格瑞玛。'),
(9417003, 0, 'zhCN', '带我回守护者图书馆。'),
(9417004, 0, 'zhCN', '询问：“卡德加有什么烦心事？”'),
(9417006, 0, 'zhCN', '我准备好了——带路吧。'),
(9417007, 0, 'zhCN', '我准备好了——带路吧。'),
(9417007, 1, 'zhCN', '我准备好了——我们继续。'),
(9417008, 0, 'zhCN', '我准备好了——带路吧。'),
(9417008, 1, 'zhCN', '我准备好了——打破冰封。');

DELETE FROM `gameobject_template_locale` WHERE `locale` = 'zhCN' AND `entry` BETWEEN 9417000 AND 9417999;
INSERT INTO `gameobject_template_locale` (`entry`, `locale`, `name`, `VerifiedBuild`) VALUES
(9417203, 'zhCN', '破碎的肯瑞托守护结界', 0),
(9417204, 'zhCN', '德尔温散落的笔记', 0),
(9417205, 'zhCN', '远古守护石', 0),
(9417206, 'zhCN', '远古守护石', 0),
(9417207, 'zhCN', '远古守护石', 0),
(9417208, 'zhCN', '梦之裂隙', 0),
(9417209, 'zhCN', '锁链锚点', 0),
(9417215, 'zhCN', '通往卡拉赞的传送门', 0),
(9417216, 'zhCN', '通往达拉然火山口的传送门', 0),
(9417217, 'zhCN', '风化的古籍', 0),
(9417226, 'zhCN', '冰墙', 0),
(9417227, 'zhCN', '冰墙', 0),
(9417228, 'zhCN', '通往达拉然火山口的传送门', 0);
-- End By leewheel
