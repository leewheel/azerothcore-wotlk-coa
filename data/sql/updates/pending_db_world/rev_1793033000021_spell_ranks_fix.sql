-- By leewheel 2026年10月26日
-- 修复 spell_ranks 校验错误：
-- 链 1022：rank3=10278 不在 Spell.dbc，若仅删 10278 剩单阶又会触发 "only 1 rank"，
--          整链删除（1022 本体作为独立法术不受影响）。
-- 链 1714：单阶行，"Spell ... has only 1 rank"，整链删除。
-- 备份：Tempfiles/db_backup_20261026/backup_round2b_20261026.txt (===spell_ranks===)

DELETE FROM spell_ranks WHERE first_spell_id IN (1022, 1714);
