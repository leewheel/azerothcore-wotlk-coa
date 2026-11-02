-- 上游核心在 spell_generic.cpp 里注册了 spell_blazing_hippogryph 与 spell_x53_touring_rocket 两个坐骑脚本，
-- 但世界库 spell_script_names 里没有对应挂载行，启动校验报
-- "Script named '...' is not assigned in the database."。
-- 这两个法术在 Spell.dbc 里都存在（74856 Blazing Hippogryph、75973 X-53 Touring Rocket），
-- 按同批坐骑脚本（spell_celestial_steed 75614、spell_invincible 72286、spell_big_love_rocket 71342）的挂法补上。
-- By leewheel 2026年11月2日
DELETE FROM `spell_script_names` WHERE (`spell_id`, `ScriptName`) IN
    ((74856, 'spell_blazing_hippogryph'), (75973, 'spell_x53_touring_rocket'));
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
    (74856, 'spell_blazing_hippogryph'),
    (75973, 'spell_x53_touring_rocket');
-- End By leewheel
