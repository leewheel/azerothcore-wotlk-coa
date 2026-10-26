-- By leewheel 2026年10月26日
-- 修复三类法术表校验错误：
-- 1) spell_cone："listed in `spell_cone` does not have a cone implicit target"——
--    8 个法术的 Effect 目标不是锥形，锥度数据无意义，删除（运行时行为不变）。
-- 2) spell_area：40579/40763 各 2 行引用的 aura_spell 40567/40576 组合已被
--    spell_linked_spell 双链接替代，为死配置，删除。
-- 3) spell_linked_spell：3 条双向重复链接（保留 (-40576,-40588)/(-40567,-40577) 单向对），
--    删除 (-45373,-45374)(-40576,-40763)(-40567,-40579)。
-- 备份：Tempfiles/db_backup_20261026/backup_round2c_20261026.txt

DELETE FROM spell_cone WHERE ID IN (11082,23023,29905,30210,37459,37461,39222,46968);

DELETE FROM spell_area WHERE spell IN (40579, 40763);

DELETE FROM spell_linked_spell WHERE
      (spell_trigger = -45373 AND spell_effect = -45374)
   OR (spell_trigger = -40576 AND spell_effect = -40763)
   OR (spell_trigger = -40567 AND spell_effect = -40579);
