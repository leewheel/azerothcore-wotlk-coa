-- 2026-11-08 上游新增内容的简体中文名补全（By leewheel）
-- 覆盖：PvP 第一赛季荣誉军需官（48051/48052/666682/49050/49051/666683）、其对话选项（9966682/9966683）、
--       血染工作台（967019）、梦境之路传送门（376296-376299）。
-- 说明：只写 zhCN 语言行，不改动英文原始数据。

-- 1) 生物名称与头衔
DELETE FROM `creature_template_locale` WHERE `entry` IN (48051, 48052, 666682, 49050, 49051, 666683) AND `locale` = 'zhCN';
INSERT INTO `creature_template_locale` (`entry`, `locale`, `Name`, `Title`, `VerifiedBuild`) VALUES
(48051, 'zhCN', '索恩中尉', '荣誉军需官', 12340),
(48052, 'zhCN', '索恩中尉', '荣誉军需官', 12340),
(666682, 'zhCN', '哈德温军需官', 'PvP 套装商人', 12340),
(49050, 'zhCN', '科加什队长', '荣誉军需官', 12340),
(49051, 'zhCN', '科加什队长', '荣誉军需官', 12340),
(666683, 'zhCN', '战争使者克罗加什', NULL, 12340);

-- 2) 对话菜单选项
DELETE FROM `gossip_menu_option_locale` WHERE `MenuID` IN (9966682, 9966683) AND `Locale` = 'zhCN';
INSERT INTO `gossip_menu_option_locale` (`MenuID`, `OptionID`, `Locale`, `OptionText`, `BoxText`) VALUES
(9966682, 0, 'zhCN', '中士的 PvP 装备', NULL),
(9966682, 1, 'zhCN', '队长的 PvP 装备', NULL),
(9966683, 0, 'zhCN', '中士的 PvP 装备', NULL),
(9966683, 1, 'zhCN', '队长的 PvP 装备', NULL);

-- 3) 游戏物件名称
DELETE FROM `gameobject_template_locale` WHERE `entry` IN (967019, 376296, 376297, 376298, 376299) AND `locale` = 'zhCN';
INSERT INTO `gameobject_template_locale` (`entry`, `locale`, `name`, `castBarCaption`, `VerifiedBuild`) VALUES
(967019, 'zhCN', '血染工作台', '', 12340),
(376296, 'zhCN', '梦境之路：梦境之枝', '', 12340),
(376297, 'zhCN', '梦境之路：荫影之枝', '', 12340),
(376298, 'zhCN', '梦境之路：暮色林地', '', 12340),
(376299, 'zhCN', '梦境之路：塞拉丹', '', 12340);
