-- By leewheel 20261110
-- 本轮上游同步（11-10）玩家可见文本汉化补齐，共 4 处：
-- 1) 迷惑血爪豺狼人（164029）被贝尔德雷德药水击杀时的喊话；
-- 2) 沙丘镇护甲商 伊蒙·灰溪（164142）的商店对话选项；
-- 3) .ptr 角色复制三条命令的帮助文本；
-- 4) 时空法师「无限视界」（560528）的法术说明。
-- End By leewheel

-- 1) 迷惑血爪豺狼人（164029）被药水击杀时的三句喊话
DELETE FROM `creature_text_locale` WHERE `CreatureID` = 164029 AND `GroupID` = 0 AND `Locale` = 'zhCN';
INSERT INTO `creature_text_locale` (`CreatureID`, `GroupID`, `ID`, `Locale`, `Text`) VALUES
(164029, 0, 0, 'zhCN', '太迟了……'),
(164029, 0, 1, 'zhCN', '啊啊啊啊！'),
(164029, 0, 2, 'zhCN', '好痛！');

-- 2) 伊蒙·灰溪（164142）的商店对话选项
DELETE FROM `gossip_menu_option_locale` WHERE `MenuID` = 1200350 AND `OptionID` = 0 AND `Locale` = 'zhCN';
INSERT INTO `gossip_menu_option_locale` (`MenuID`, `OptionID`, `Locale`, `OptionText`, `BoxText`) VALUES
(1200350, 0, 'zhCN', '我想看看你的货。', '');

-- 3) .ptr 角色复制命令帮助（命令名保持英文，帮助内容汉化）
UPDATE `command` SET `help` = '语法：.ptr <list|copy>。把你在本服的角色复制到测试服，请在角色所在的服务器上使用。' WHERE `name` = 'ptr';
UPDATE `command` SET `help` = '语法：.ptr list。列出你在本服的角色，以及它们最近一次复制到测试服的状态。' WHERE `name` = 'ptr list';
UPDATE `command` SET `help` = '语法：.ptr copy <角色名>。把你名为 <角色名> 的角色复制到测试服，就绪后会在这里通知你；若该名字已被占用，登录时可重新取名。' WHERE `name` = 'ptr copy';

-- 4) 时空法师「无限视界」（560528）法术说明
DELETE FROM `coa_client_spell_description` WHERE `ID` = 560528;
INSERT INTO `coa_client_spell_description` (`ID`, `Description`, `ToolTip`) VALUES
(560528, '使小队与团队成员造成的所有伤害提高 $s1%，不与同类效果叠加。\r\n\r\n此外，你的 |cFFFFFFFFUnmake|r 与 |cFFFFFFFFTimerend|r 额外获得 $s2% 的法术伤害加成。', NULL);
