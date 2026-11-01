-- 补 rev_20261101_30_coa_tanaris_restore.sql 漏插的 creature_model_info 两行。
-- 上游该迁移只插了 creature_template_model（255335 Cerulis 用 35513、449402 Barnabas 用 30244），
-- 未插对应模型数据，导致服务端启动报 "No model data exist for CreatureDisplayID"。
-- 两个 DisplayID 的 CreatureModelData（3628 / 3194）几何参数一致：
--   BoundingRadius = f14 = 0.6111、CombatReach = f15 = 2.0313，与项目既往补行惯例取值相同。
-- By leewheel 2026年11月1日
DELETE FROM `creature_model_info` WHERE `DisplayID` IN (35513, 30244);
INSERT INTO `creature_model_info` (`DisplayID`, `BoundingRadius`, `CombatReach`, `Gender`, `DisplayID_Other_Gender`) VALUES
(35513, 0.6111109852790833, 2.031280040740967, 2, 0),
(30244, 0.6111109852790833, 2.031280040740967, 2, 0);
-- End By leewheel
