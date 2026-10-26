-- By leewheel 2026年10月26日
-- 修复两类 spell_group 校验错误：
-- 1) "is not first rank of spell group"：22 条高阶法术挂在组里但首阶缺失/不为首阶，
--    这些 ID 均为高等级 rank，从所有组中移除（首阶已在组内，行为不变）。
-- 2) "Spell ... triggers stacking of aura ... but they are in different groups"：
--    6 条与首阶分属不同组的 aura，按 (组, 法术) 精确删除（同法术在其他组合法共存）。
-- 备份：Tempfiles/db_backup_20261026/backup_round2b_20261026.txt (===spell_group===)

DELETE FROM spell_group WHERE spell_id IN (
300882,300883,300884,300885,300886,300916,300917,300918,300919,300923,
503319,503320,503321,503322,503323,578312,578313,578314,578315,681439,681440,681441
);

DELETE FROM spell_group WHERE (id = 1122 AND spell_id = 10060)
   OR (id = 1056 AND spell_id = 31579)
   OR (id = 1054 AND spell_id = 50170)
   OR (id = 1019 AND spell_id = 50274)
   OR (id = 1059 AND spell_id = 55095)
   OR (id = 1038 AND spell_id = 67480);
