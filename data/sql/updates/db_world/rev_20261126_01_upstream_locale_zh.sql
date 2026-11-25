-- By leewheel 20261126 本轮上游合并的玩家可见文本汉化
-- 工法：不改上游 SQL 一行一列，只用 locale 覆盖表写中文，保证上游文件 hash 不变。
-- End By leewheel

-- NPC 名：索戈斯世界首领、三位先驱、被遗忘的化身（本体与副本版）
DELETE FROM `creature_template_locale` WHERE `entry` IN (978077, 64606, 64607, 64608, 501004, 501005) AND `locale` = 'zhCN';
INSERT INTO `creature_template_locale` (`entry`, `locale`, `Name`, `Title`, `VerifiedBuild`) VALUES
(978077, 'zhCN', '索戈斯之意志', NULL, 0),
(64606, 'zhCN', '柯尔拉，暮光使者', NULL, 0),
(64607, 'zhCN', '高阶女祭司艾萨尔', NULL, 0),
(64608, 'zhCN', '德拉加·影焚', NULL, 0),
(501004, 'zhCN', '被遗忘的化身', NULL, 0),
(501005, 'zhCN', '被遗忘的化身', NULL, 0);

-- 物件名：索戈斯神龛、离开胃渊的传送门、被遗忘的日志 / 木板 / 护符 / 坟墓
DELETE FROM `gameobject_template_locale` WHERE `entry` IN (280144, 978078, 978079, 501000, 501001, 501002, 501003, 501006) AND `locale` = 'zhCN';
INSERT INTO `gameobject_template_locale` (`entry`, `locale`, `name`, `castBarCaption`, `VerifiedBuild`) VALUES
(280144, 'zhCN', '索戈斯神龛', NULL, 0),
(978079, 'zhCN', '索戈斯神龛', NULL, 0),
(978078, 'zhCN', '离开胃渊的传送门', NULL, 0),
(501000, 'zhCN', '被遗忘的日志', NULL, 0),
(501001, 'zhCN', '腐朽的木板', NULL, 0),
(501002, 'zhCN', '被遗忘的护符', NULL, 0),
(501003, 'zhCN', '被遗忘的坟墓', NULL, 0),
(501006, 'zhCN', '被遗忘的坟墓', NULL, 0);

-- 神龛的耳语（npc_text）
DELETE FROM `npc_text_locale` WHERE `ID` = 978077 AND `Locale` = 'zhCN';
INSERT INTO `npc_text_locale` (`ID`, `Locale`, `Text0_0`, `Text0_1`) VALUES
(978077, 'zhCN',
 '当你的手按在神龛表面、与它的力量共鸣时，神龛似乎察觉到了你的存在。',
 '当你的手按在神龛表面、与它的力量共鸣时，神龛似乎察觉到了你的存在。');

-- 被遗忘的日志书页（page_text）
DELETE FROM `page_text_locale` WHERE `ID` = 501000 AND `locale` = 'zhCN';
INSERT INTO `page_text_locale` (`ID`, `locale`, `Text`, `VerifiedBuild`) VALUES
(501000, 'zhCN',
 '我见过，最黑暗的生灵身上也有希望。上一次，是你教会了我这一点。如果我能再找到你，也许你能帮我，可我找不到你，找不到她，也找不到从前见过的任何人。\n他们是我唯一还记得的人，可我已经不知道该怎么办了。他们陷进黑暗太深，我再也没法把他们救回来。我明明是他们双生的那一个，不该比谁都更能接近他们吗？\n\n但我不能放弃。我要把还能记住的都记下来，所以写下这些，也许下一次我还能再找到它。\n有一次我们一起进了地窖，他们在那儿掉了一条项链。从前湖边开着一种花，是他们最喜欢的花，现在却很难找到了。路边有一座他们的坟……可其实并不是。只是那时候我不知道该怎么解释发生的事。\n\n现在我还是不知道……\n可那件事不是比这座镇子还要早很多吗？那怎么会是他们呢？一切都那么模糊……我得再想起一些。',
 0);

-- End By leewheel
