-- By leewheel 2026年10月26日 coa_dungeon_health 孤儿行清理（Errors.log 36 条）
-- 全部 36 条失败原因均为 creature_entry 在 creature_template 不存在（Creature.cpp:79-85 会 continue 忽略）。
-- 全表已备份 Tempfiles/db_backup_20261026/backup_coa_dungeon_health_20261026.txt
DELETE FROM `coa_dungeon_health` WHERE `creature_entry` IN (11855,40008,80070,80274,80276,83755,91999,92117,92143,111004,160434,160513,161845,254687,801853,1000068) AND `creature_entry` NOT IN (SELECT `entry` FROM `creature_template`);
