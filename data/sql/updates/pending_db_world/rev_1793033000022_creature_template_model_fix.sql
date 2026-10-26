-- By leewheel 2026年10月26日
-- 修复两类 creature_template_model 校验错误：
-- 1) "Creature template (Entry: X) does not exist but has a record in creature_template_model"：
--    13 条孤儿模型行（模板已删除），直接删除。
-- 2) 生物无模型行（"Creature (Entry: X) has no model listed in creature_template_model"）：
--    6 个 credit 生物补 display 48504（与同级 80420/80421 一致）；
--    900001-900004 补隐形 display 16925，同时 faction 由 0 置 35（中立可攻击目标）。
-- 备份：Tempfiles/db_backup_20261026/backup_round2b_20261026.txt (===ctm_orphan===)

DELETE FROM creature_template_model WHERE CreatureID IN (
45773,137357,162815,162816,162825,162934,162935,162936,162937,162948,254612,254822,502955
);

INSERT INTO creature_template_model (CreatureID, Idx, CreatureDisplayID, DisplayScale, Probability, VerifiedBuild) VALUES
(80027, 0, 48504, 1, 1, NULL),
(80652, 0, 48504, 1, 1, NULL),
(81041, 0, 48504, 1, 1, NULL),
(81042, 0, 48504, 1, 1, NULL),
(101000, 0, 48504, 1, 1, NULL),
(101001, 0, 48504, 1, 1, NULL),
(900001, 0, 16925, 1, 1, NULL),
(900002, 0, 16925, 1, 1, NULL),
(900003, 0, 16925, 1, 1, NULL),
(900004, 0, 16925, 1, 1, NULL);

UPDATE creature_template SET faction = 35 WHERE entry IN (900001,900002,900003,900004) AND faction = 0;
