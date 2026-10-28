-- By leewheel 2026年10月26日
-- 修复 gameobject/pool/event 校验错误：
-- 1) GO 195002 (Thunderkeg)：~~删模板~~ 【2026-10-28 修正】当时误判"无引用"——
--    spell 807849 (Stormbringer Conjure Thunderkeg) 是 SPELL_EFFECT_TRANS_DOOR 且
--    EffectMiscValue=195002，门禁运行时报 "Gameobject (Entry: 195002) not exist"。
--    正确修法 = 保留/补建模板（见 rev_20260930_93 与 rev_1793033000031），本文件不再删除。
-- 2) GO spawn 6942486/6942488：spawntimesecs=0 但被标记为可 despawn，置 300 秒（非 0 即可）。
-- 3) GO spawn 6942539：引用不存在的模板 101911，删除。
-- 4) pool_creature 134008：指向不存在的 creature spawn，删除。
-- 5) game_event_creature (event 120, guid 248653)：指向不存在的 creature，删除。
-- 备份：Tempfiles/db_backup_20261026/backup_round2d_20261026.txt

UPDATE gameobject SET spawntimesecs = 300 WHERE guid IN (6942486, 6942488);

DELETE FROM gameobject WHERE guid = 6942539;

DELETE FROM pool_creature WHERE guid = 134008;

DELETE FROM game_event_creature WHERE guid = 248653;
