-- By leewheel 2026年11月25日
-- Errors.log 治理：本轮上游合并（#13351 等）引入的启动告警清理
-- 1) spell_proc 无效掩码清零：ProcFlags 不含对应位时掩码不会生效（校验在 SpellMgr.cpp 2486/2492），清零不改变游戏行为，参照 rev_1793033000034 第 2 条工法
-- 2) 补灌历史 pending 中漏灌的 spell_script_names 绑定（脚本已注册但 DB 无挂载会报 "not assigned in the database"）
-- 3) 删除 glyph_of_starfire_dummy 死注册绑定（C++ 注册已于 2026-10-26 注销，DB 残留会报 "assigned ... but has no code"）

-- 1a) SpellPhaseMask 无效：清 0
UPDATE `spell_proc` SET `SpellPhaseMask` = 0 WHERE `SpellId` IN
(84380, 273795, 276344, 282209, 284591, 284711, 299031, 299162, 832713, 954092, 954376, 982567, 986164, 1571107, 1576859, 1587677, 1590425);

-- 1b) SpellTypeMask 无效：清 0
UPDATE `spell_proc` SET `SpellTypeMask` = 0 WHERE `SpellId` IN
(276344, 986164, 1576859, 1590425);

-- 2a) venomancer sea serpent incarnation 绑定（历史 pending rev_20261121_40 漏灌）
DELETE FROM `spell_script_names` WHERE `spell_id` = 803212 AND `ScriptName` = 'aura_ascension_venomancer_sea_serpent_incarnation';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES (803212, 'aura_ascension_venomancer_sea_serpent_incarnation');

-- 2b) necromancer command area 绑定（历史 pending rev_20261121_11573 漏灌）
DELETE FROM `spell_script_names` WHERE `spell_id` IN (570042, 801514, 504022, 801411, 505229) AND `ScriptName` = 'spell_ascension_necromancer_command_area';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(570042, 'spell_ascension_necromancer_command_area'),
(801514, 'spell_ascension_necromancer_command_area'),
(504022, 'spell_ascension_necromancer_command_area'),
(801411, 'spell_ascension_necromancer_command_area'),
(505229, 'spell_ascension_necromancer_command_area');

-- 3) glyph_of_starfire_dummy：C++ 注册已于 2026-10-26 注销，本轮 rev_20261121_dummyfix_druid.sql 又绑回，清掉残留
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'spell_dru_glyph_of_starfire_dummy';
-- End By leewheel 2026年11月25日
