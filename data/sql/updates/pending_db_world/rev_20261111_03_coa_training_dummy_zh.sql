-- By leewheel 2026年11月11日
-- 动态训练假人（上游 #11944）6 个新生物的中文名。
-- 上游 rev_20261110_dynamic_training_dummies.sql 只写 creature_template 英文名，
-- 这里用 creature_template_locale 覆盖，不改上游 SQL 的任何一行一列。
-- 对应关系：
--   666925 Dynamic Execute Training Dummy  -> 动态斩杀训练假人
--   666935 Dynamic Healing Training Dummy  -> 动态治疗训练假人
--   967171 Configurable Training Dummy     -> 可配置训练假人
--   967182 Dynamic Tank Training Dummy     -> 动态坦克训练假人
--   967254 Dynamic Training Dummy          -> 动态训练假人
--   9780200 Boss Simulator                 -> 首领模拟器
INSERT INTO `creature_template_locale` (`entry`, `locale`, `Name`, `Title`, `VerifiedBuild`) VALUES
(666925, 'zhCN', '动态斩杀训练假人', NULL, 0),
(666935, 'zhCN', '动态治疗训练假人', NULL, 0),
(967171, 'zhCN', '可配置训练假人', NULL, 0),
(967182, 'zhCN', '动态坦克训练假人', NULL, 0),
(967254, 'zhCN', '动态训练假人', NULL, 0),
(9780200, 'zhCN', '首领模拟器', NULL, 0)
ON DUPLICATE KEY UPDATE `Name` = VALUES(`Name`), `Title` = VALUES(`Title`);

-- End By leewheel
