-- By leewheel 2026年10月26日
-- 修复 item_template 校验错误（每条与核心报错一一对应）：
-- 1) "has flag ITEM_FLAGS_CU_DURATION_REAL_TIME but it does not have duration limit"：
--    10 个物品 FlagsCustom 含 0x0001 但 Duration=0，清该位（Duration=0 时实时计时无意义）。
-- 2) "has wrong TotemCategory"：52723(209)/60223(210)/6060223(210) 置 0。
-- 3) "has wrong Sheath (0), must be 8"：80580/6089578/6089579 Sheath 置 8。
-- 4) "wrong (not existing) spell in spellid_2"：262673 的 84387 不存在，置 0。
-- 5) "currency bag family bit set in BagFamily but not listed in CurrencyTypes.dbc"：
--    975001 BagFamily 置 0。
-- 6) "wrong InventoryType value (8), must be 10"：6010801 置 10。
-- 7) item_loot_template 1397885（Adventurer's Cache，2459 行有意设计的掉落表）报
--    "isn't item entry and not referenced from loot"：物品存在但缺 ITEM_FLAG_HAS_LOOT(0x4)，
--    给 Flags 补该位（保留全部掉落数据）。
-- 备份：Tempfiles/db_backup_20261026/backup_round2c_20261026.txt

UPDATE item_template SET FlagsCustom = FlagsCustom & ~0x0001 WHERE Duration = 0 AND entry IN
(44858,44859,44860,44861,44862,46803,46804,46805,46806,46807);

UPDATE item_template SET TotemCategory = 0 WHERE entry IN (52723, 60223, 6060223);

UPDATE item_template SET Sheath = 8 WHERE entry IN (80580, 6089578, 6089579);

UPDATE item_template SET spellid_2 = 0 WHERE entry = 262673;

UPDATE item_template SET BagFamily = 0 WHERE entry = 975001;

UPDATE item_template SET InventoryType = 10 WHERE entry = 6010801;

UPDATE item_template SET Flags = Flags | 0x00000004 WHERE entry = 1397885;
