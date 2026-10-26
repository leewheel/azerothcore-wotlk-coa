-- 删除 reference_loot_template 中 29 个无引用死条目
-- 核心 LootMgr 报 "Entry N isn't reference id and not referenced from loot, and thus useless"
-- 即不被任何 loot 表 Reference 引用、自身也不是有效 reference 链，删除无玩法影响
-- 原值备份 Tempfiles/db_backup_20261026/backup_ref_loot_orphans.txt
-- By leewheel 2026年10月26日
DELETE FROM reference_loot_template WHERE Entry IN (30001,30338,30339,30340,30343,30344,30345,30349,30350,30352,30353,30354,30355,30356,30357,30365,30366,30367,30368,30484,30485,30488,30547,30549,30550,1409000,9002011,9002012,9002013);
