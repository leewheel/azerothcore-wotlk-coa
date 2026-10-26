-- By leewheel 2026年10月26日
-- 修复 instance_encounters 与 disables 校验错误：
-- 1) "marked as final for invalid dungeon id"：1381/1586/1589/1591 的 lastEncounterDungeon
--    为无效地下城 ID（2727/2693/2721/2725，CoA Heroic 自造 ID 不被地图表接受），置 0。
-- 2) "specified encounter X as last encounter but Y is already marked as one"：
--    2245/2280/2981-2986 与既有最后首领（245/2275/2230）重复，取消其 last 标记（置 0）。
-- 3) disables 三条无效引用行删除：
--    (sourceType=2, entry=937, flags=15) 未开放副本锁定、(sourceType=4, 12681/12801) 无效 quest 关闭。
-- 备份：Tempfiles/db_backup_20261026/backup_round2d_20261026.txt

UPDATE instance_encounters SET lastEncounterDungeon = 0 WHERE entry IN (1381, 1586, 1589, 1591);

UPDATE instance_encounters SET lastEncounterDungeon = 0 WHERE entry IN (2245, 2280, 2981, 2982, 2983, 2984, 2985, 2986);

DELETE FROM disables WHERE (sourceType = 2 AND entry = 937 AND flags = 15)
   OR (sourceType = 4 AND entry = 12681)
   OR (sourceType = 4 AND entry = 12801);
