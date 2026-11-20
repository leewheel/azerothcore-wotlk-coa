-- By leewheel 20261120
-- #12992 军需官米兰达·布利洛克（11536）在玩家没拿到银色黎明委任状（5401、5405、5503）之前不开店，
-- 但她的原对话 4213 从来没说明这一点。现在没委任状时改用新对话 1153600，把玩家指引去找尼古拉斯·兹维伦霍夫公爵；
-- 4213 保留相反的条件，确保任何时刻只有一段文本命中。
-- 下面两条贩售条目来自 SUB npc_vendor（db.exil.es 导出，2026-10-04），本服此前没有任何地方卖。
-- 中文对话走 npc_text_locale，主表保留英文原文
-- End By leewheel
DELETE FROM `npc_text` WHERE `ID` = 1153600;
INSERT INTO `npc_text` (`ID`, `text0_0`, `text0_1`, `BroadcastTextID0`, `lang0`, `Probability0`, `VerifiedBuild`)
VALUES
(1153600,
    'Greetings, $c.  I supply only those who serve the Dawn under an official commission.$B$B'
    'Speak with Duke Nicholas Zverenhoff here at the chapel.  Once you carry the Dawn\'s commission, '
    'my stores are open to you.',
    'Greetings, $c.  I supply only those who serve the Dawn under an official commission.$B$B'
    'Speak with Duke Nicholas Zverenhoff here at the chapel.  Once you carry the Dawn\'s commission, '
    'my stores are open to you.',
    0, 0, 1, 0);

DELETE FROM `gossip_menu` WHERE `MenuID` = 3461 AND `TextID` = 1153600;
INSERT INTO `gossip_menu` (`MenuID`, `TextID`) VALUES (3461, 1153600);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 14 AND `SourceGroup` = 3461
    AND `SourceEntry` IN (4213, 1153600);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`,
    `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`,
    `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(14, 3461, 1153600, 0, 0, 8, 0, 5401, 0, 0, 1, 0, 0, '', 'Miranda - Commission greeting - no Alliance Commission'),
(14, 3461, 1153600, 0, 0, 8, 0, 5405, 0, 0, 1, 0, 0, '', 'Miranda - Commission greeting - no Horde Commission'),
(14, 3461, 1153600, 0, 0, 8, 0, 5503, 0, 0, 1, 0, 0, '', 'Miranda - Commission greeting - no Commission'),
(14, 3461, 4213, 0, 0, 8, 0, 5401, 0, 0, 0, 0, 0, '', 'Miranda - greeting 4213 - Alliance Commission rewarded'),
(14, 3461, 4213, 0, 1, 8, 0, 5405, 0, 0, 0, 0, 0, '', 'Miranda - greeting 4213 - Horde Commission rewarded'),
(14, 3461, 4213, 0, 2, 8, 0, 5503, 0, 0, 0, 0, 0, '', 'Miranda - greeting 4213 - Commission rewarded');

DELETE FROM `npc_vendor` WHERE `ExtendedCost` = 0
    AND ((`entry` = 11536 AND `item` = 46517) OR (`entry` = 12944 AND `item` = 46519));
INSERT INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`) VALUES
(11536, 0, 46517, 0, 0, 0, 0),
(12944, 0, 46519, 0, 0, 0, 0);

-- 米兰达的中文对话
DELETE FROM `npc_text_locale` WHERE `ID` = 1153600 AND `Locale` = 'zhCN';
INSERT INTO `npc_text_locale` (`ID`, `Locale`, `Text0_0`, `Text0_1`) VALUES
(1153600, 'zhCN',
    '你好，$c。我只为持有正式委任状、为黎明而战的人供货。$B$B去礼拜堂找尼古拉斯·兹维伦霍夫公爵吧。等你拿到黎明的委任状，我的货架就为你敞开。',
    '你好，$c。我只为持有正式委任状、为黎明而战的人供货。$B$B去礼拜堂找尼古拉斯·兹维伦霍夫公爵吧。等你拿到黎明的委任状，我的货架就为你敞开。');
