-- By leewheel 2026年11月8日
-- 修复 rev_20261108_01_high_risk_refineries.sql 引入的两条非法模型显示 ID。
-- 该 SQL 为两个高风险精英填的 CreatureDisplayID 在本服客户端 CreatureDisplayInfo.dbc 中不存在，
-- worldserver 每次启动都会往 Errors.log 写：
--   No model data exist for `CreatureDisplayID` = 511293 listed by creature (Entry: 918578).
--   No model data exist for `CreatureDisplayID` = 556828 listed by creature (Entry: 997440).
-- 处理：换成同族生物正在使用、且客户端确实存在的模型显示 ID（不是删除，也不是屏蔽报错）。
--   918578 阿科兰的选民（施法者）  → 11293（阿科兰神谕者 6138 的模型）
--   997440 冬泉酿酒师（熊怪）      → 6830 （冬泉萨满祭司 7439 的模型）
-- 可重复执行：条件限定「当前仍是那条非法 ID」才更新。
-- End By leewheel

UPDATE `creature_template_model` SET `CreatureDisplayID` = 11293
WHERE `CreatureID` = 918578 AND `CreatureDisplayID` = 511293;

UPDATE `creature_template_model` SET `CreatureDisplayID` = 6830
WHERE `CreatureID` = 997440 AND `CreatureDisplayID` = 556828;
