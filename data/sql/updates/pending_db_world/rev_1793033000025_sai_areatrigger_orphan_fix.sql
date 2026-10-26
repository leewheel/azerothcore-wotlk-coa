-- By leewheel 2026年10月26日
-- 修复孤儿 SAI 与区域触发器引用：
-- 1) smart_scripts (10185, source_type=0)：生物模板 10185 已不存在，8 行孤儿 SAI 删除。
-- 2) smart_scripts (6164, source_type=2)：areatrigger_scripts 6164 同步删除（见下）。
-- 3) areatrigger_teleport 8004/8005：引用不存在的目标配置，删除。
-- 4) areatrigger_scripts 6164：脚本目标缺失（错误清单 ev/sp 类），删除。
-- 备份：Tempfiles/db_backup_20261026/backup_round2c_20261026.txt

DELETE FROM smart_scripts WHERE (entryorguid = 10185 AND source_type = 0)
   OR (entryorguid = 6164 AND source_type = 2);

DELETE FROM areatrigger_teleport WHERE ID IN (8004, 8005);

DELETE FROM areatrigger_scripts WHERE entry = 6164;
