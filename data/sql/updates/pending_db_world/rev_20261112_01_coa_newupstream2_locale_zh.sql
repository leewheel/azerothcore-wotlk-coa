-- 2026-11-12 上游合并（19 个提交）新增玩家可见文本中文化
-- By leewheel 2026年11月12日
-- 覆盖对象：rev_20261107_15（雪冢世界首领）、rev_20261109_11（泽莱玛尔）、rev_20261107_12（哀嚎洞穴快速护送）
-- 文件名排序在本批上游更新之后，保证基础行先插入、locale 再覆盖

-- 1) 世界首领「雪冢」本体名称
INSERT INTO `creature_template_locale` (`entry`, `locale`, `Name`, `Title`)
VALUES (978095, 'zhCN', '雪冢', '')
ON DUPLICATE KEY UPDATE `Name` = VALUES(`Name`);

-- 2) 神龛、传送门、冰锥物件名
INSERT INTO `gameobject_template_locale` (`entry`, `locale`, `name`, `castBarCaption`)
VALUES
(978095, 'zhCN', '雪冢神殿', ''),
(978096, 'zhCN', '通往冬泉谷的传送门', ''),
(978097, 'zhCN', '雪冢神殿', ''),
(978098, 'zhCN', '坠落的冰锥', '')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- 3) 神龛感应文本
INSERT INTO `npc_text_locale` (`ID`, `locale`, `text0_0`, `text0_1`)
VALUES (978095, 'zhCN',
'当你把手按在神殿表面、试图与它的力量共鸣时，神殿似乎察觉到了你的存在。',
'当你把手按在神殿表面、试图与它的力量共鸣时，神殿似乎察觉到了你的存在。')
ON DUPLICATE KEY UPDATE `text0_0` = VALUES(`text0_0`), `text0_1` = VALUES(`text0_1`);

-- 4) 泽莱玛尔登场与狂暴台词（上游已删旧行，这里先清 locale 再补，避免旧译文错位）
DELETE FROM `creature_text_locale` WHERE `CreatureID` = 17830;
INSERT INTO `creature_text_locale` (`CreatureID`, `GroupID`, `ID`, `locale`, `Text`)
VALUES
(17830, 0, 0, 'zhCN', '是谁胆敢召唤我！'),
(17830, 1, 0, 'zhCN', '%s 变得狂暴了！');

-- 5) 哀嚎洞穴：纳拉雷克斯信徒的快速护送对话选项
INSERT INTO `gossip_menu_option_locale` (`MenuID`, `OptionID`, `locale`, `OptionText`, `BoxText`)
VALUES (201, 1, 'zhCN', '我时间不多了，我们快走！', '')
ON DUPLICATE KEY UPDATE `OptionText` = VALUES(`OptionText`);

-- End By leewheel
