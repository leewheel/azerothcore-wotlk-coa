-- 2026.11.20 克拉斯蒂诺夫的「恐怖之袋」13725（议题 #12784）：任务 5515「恐怖之袋」需要詹迪斯·巴罗夫的袋子。
-- 她的普通难度掉落 10503 对已接任务的玩家 100% 给，但 rev_20261009_70 重写过的英雄/秘境掉落表
-- 110503 与 210503 里没有这个任务物品，所以英雄或秘境击杀永远不掉。这里照抄普通难度那一行。
-- 上游 #12817（世界任务批次 9）。// By leewheel 20261120
DELETE FROM `creature_loot_template` WHERE `Entry` IN (110503, 210503) AND `Item` = 13725;
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`,
    `MinCount`, `MaxCount`, `Comment`) VALUES
(110503, 13725, 0, 100, 1, 1, 0, 1, 1, 'Jandice Barov (Heroic) - Krastinov''s Bag of Horrors'),
(210503, 13725, 0, 100, 1, 1, 0, 1, 1, 'Jandice Barov (Mythic) - Krastinov''s Bag of Horrors');
