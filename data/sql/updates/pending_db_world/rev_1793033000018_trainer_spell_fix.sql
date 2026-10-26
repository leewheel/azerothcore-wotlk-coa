-- 删除 trainer_spell 中 12 行引用不存在法术的数据
-- 核心加载时报 "Table `trainer_spell` references non-existing spell (SpellId: N) for TrainerId N, ignoring"
-- 法术在 Spell.dbc 不存在，教了也无法学会，删除无玩法影响
-- 原值备份 Tempfiles/db_backup_20261026/backup_trainer_spell_rows.txt
-- By leewheel 2026年10月26日
DELETE FROM trainer_spell WHERE TrainerID=3 AND SpellId IN (5599,10278);
DELETE FROM trainer_spell WHERE TrainerID=4 AND SpellId IN (5599,10278);
DELETE FROM trainer_spell WHERE TrainerID=5 AND SpellId IN (5599,10278);
DELETE FROM trainer_spell WHERE TrainerID=31 AND SpellId=11719;
DELETE FROM trainer_spell WHERE TrainerID=72 AND SpellId IN (31460,55898);
DELETE FROM trainer_spell WHERE TrainerID=73 AND SpellId=31460;
DELETE FROM trainer_spell WHERE TrainerID=200001 AND SpellId IN (31460,55898);
