-- 2026.11.20 拉斯·霜语的人头 13626（议题 #12785）：任务 5466「巫妖」需要这颗人头。
-- 他的普通难度掉落 10508 在「魂契纪念品」把他变回人类之后（通灵学院实例数据 2 = 1）对已接任务的玩家 100% 给，
-- 但 rev_20261009_70 重写过的英雄/秘境掉落表 110508 与 210508 里没有这个任务物品，所以英雄或秘境击杀永远不掉。
-- 这里照抄普通难度那一行以及它的「人类形态」判定条件。
-- 上游 #12817（世界任务批次 9）。// By leewheel 20261120
DELETE FROM `creature_loot_template` WHERE `Entry` IN (110508, 210508) AND `Item` = 13626;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`,
    `MinCount`, `MaxCount`, `Comment`) VALUES
(110508, 13626, 0, 100, 1, 1, 0, 1, 1, 'Ras Frostwhisper (Heroic) - Human Head of Ras Frostwhisper'),
(210508, 13626, 0, 100, 1, 1, 0, 1, 1, 'Ras Frostwhisper (Mythic) - Human Head of Ras Frostwhisper');

DELETE FROM `conditions`
WHERE `SourceTypeOrReferenceId` = 1 AND `SourceGroup` IN (110508, 210508) AND `SourceEntry` = 13626;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`,
    `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`,
    `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(1, 110508, 13626, 0, 0, 13, 0, 2, 1, 0, 0, 0, 0, '',
    'Instance - Get Data - Can only loot ''Human Head of Ras Frostwhisper'' (Heroic) if Ras is in human form'),
(1, 210508, 13626, 0, 0, 13, 0, 2, 1, 0, 0, 0, 0, '',
    'Instance - Get Data - Can only loot ''Human Head of Ras Frostwhisper'' (Mythic) if Ras is in human form');
