-- By leewheel 2026年10月26日
-- 修复装备/成就/脚本表校验错误：
-- 1) creature spawn 92031-92033：equipment_id=1 在 creature_equip_template 不存在，置 0。
-- 2) creature_equip_template：19542 的 28354 不可手中装备、502873 的 2000048 物品不存在，
--    核心运行时已强制 ItemID1=0，DB 同步置 0。
-- 3) achievement_criteria_data：criteria 9098/9099/9619 的 DBC criteria type=8 不被 data 表支持
--    （"has data for non-supported criteria type, ignored"），删除这 3 行死数据。
-- 4) spell_scripts：24320/47958/51662/57082 的 effect 0 不是 SCRIPT_EFFECT/DUMMY，
--    DB 脚本永不触发，删除。
-- 5) event_scripts：8328/11413/11674/15452/17841/18475 不指向任何有效 GO/法术效果，删除。
-- 备份：Tempfiles/db_backup_20261026/backup_round2d + round2e_20261026.txt

UPDATE creature SET equipment_id = 0 WHERE id IN (92031, 92032, 92033);

UPDATE creature_equip_template SET ItemID1 = 0 WHERE CreatureID = 19542 AND ID = 1;

UPDATE creature_equip_template SET ItemID1 = 0 WHERE CreatureID = 502873 AND ID = 1;

DELETE FROM achievement_criteria_data WHERE criteria_id IN (9098, 9099, 9619);

DELETE FROM spell_scripts WHERE id IN (24320, 47958, 51662, 57082);

DELETE FROM event_scripts WHERE Id IN (8328, 11413, 11674, 15452, 17841, 18475);
