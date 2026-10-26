-- By leewheel 2026年10月26日
-- 修复："Script named 'spell_ascension_pet_lowest_health_allies' is assigned in the database,
-- but has no code"——代码侧注册名为带命名空间前缀的 AscensionTaming::spell_ascension_pet_lowest_health_allies，
-- DB spell_script_names 行缺前缀导致反向校验失败。DB 行补前缀（挂载语义不变）。
-- 备份：无需（UPDATE 语句可逆，原值为无前缀同名）

UPDATE spell_script_names SET ScriptName = 'AscensionTaming::spell_ascension_pet_lowest_health_allies'
WHERE ScriptName = 'spell_ascension_pet_lowest_health_allies';
