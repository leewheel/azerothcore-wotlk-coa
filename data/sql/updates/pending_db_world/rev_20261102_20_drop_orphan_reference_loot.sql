-- 节日掉落迁移收尾：上游 2026-11-01 的三支脚本（rev_20261101_81_coren_direbrew_coa_loot、
-- rev_20261101_82_apothecary_hummel_coa_loot、rev_20261101_83_holiday_boxes_level_80_loot）把
-- Coren Direbrew 的六件饰品（reference 34284）与 Apothecary Hummel 的五件项链（reference 50010）
-- 改成显式掉落行，并删掉了全部引用行，但没有删这两个 reference 组本身。
-- 结果核心启动校验报错：reference_loot_template Entry 34284/50010 isn't reference id and not referenced
-- from loot, and thus useless。这里把已无任何引用的两组 reference 行清掉，补完那次迁移。
-- By leewheel 2026年11月2日
DELETE FROM `reference_loot_template` WHERE `Entry` IN (34284, 50010);
-- End By leewheel
