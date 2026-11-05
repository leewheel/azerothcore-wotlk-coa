-- 接 rev_20261106_01：难度 2（神话）模板同样不能填 ScriptName，清空 Blackrock Caverns 的 25 条难度 2 模板。
-- By leewheel 2026年11月06日
UPDATE `creature_template` SET `ScriptName` = ''
WHERE `entry` IN (239665,239679,239698,239700,239705,239708,239978,239980,239982,239985,239987,239990,
                  239994,240008,240011,240015,240017,240019,240021,240023,240084,240447,240817,250284,250376)
  AND `ScriptName` <> '';
-- End By leewheel
