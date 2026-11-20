-- By leewheel 20261120
-- #13001 厄运之槌：大法师卡兰德里斯的心灵鞭笞与心灵震爆伤害对齐实测日志
-- 英雄难度心灵鞭笞每跳 525 降到 177（乘 0.337），神话难度 367 降到 230（乘 0.627）
-- 英雄难度心灵震爆约 1982 降到 892（乘 0.45），神话难度约 2015 降到 1159（乘 0.575）
-- End By leewheel
DELETE FROM `coa_dungeon_creature_damage` WHERE `entry` = 11487 AND `spell_id` IN (2100199, 2100200, 2100240, 2100241);
INSERT INTO `coa_dungeon_creature_damage` (`entry`, `spell_id`, `multiplier`, `comment`) VALUES
    (11487, 2100240, 0.337, 'Magister Kalendris: Mind Flay (Heroic) 525 -> 177 per tick, Mythic / 1.3'),
    (11487, 2100241, 0.627, 'Magister Kalendris: Mind Flay (Mythic) 367 -> 230 per tick, as in the Mythic+ logs'),
    (11487, 2100199, 0.45, 'Magister Kalendris: Mind Blast (Heroic) about 1982 -> 892, Mythic / 1.3'),
    (11487, 2100200, 0.575, 'Magister Kalendris: Mind Blast (Mythic) about 2015 -> 1159, as in the Mythic+ logs');
