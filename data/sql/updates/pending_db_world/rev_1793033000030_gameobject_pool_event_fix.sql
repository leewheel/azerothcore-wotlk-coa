-- By leewheel 2026年10月26日
-- 修复 gameobject/pool/event 校验错误：
-- 1) GO 195002 (Thunderkeg, type 22 Trap)：data0=0 指向不存在的法术 0，无 spawn 无引用，删模板。
-- 2) GO spawn 6942486/6942488：spawntimesecs=0 但被标记为可 despawn，置 300 秒（非 0 即可）。
-- 3) GO spawn 6942539：引用不存在的模板 101911，删除。
-- 4) pool_creature 134008：指向不存在的 creature spawn，删除。
-- 5) game_event_creature (event 120, guid 248653)：指向不存在的 creature，删除。
-- 备份：Tempfiles/db_backup_20261026/backup_round2d_20261026.txt

DELETE FROM gameobject_template WHERE entry = 195002;

UPDATE gameobject SET spawntimesecs = 300 WHERE guid IN (6942486, 6942488);

DELETE FROM gameobject WHERE guid = 6942539;

DELETE FROM pool_creature WHERE guid = 134008;

DELETE FROM game_event_creature WHERE guid = 248653;
