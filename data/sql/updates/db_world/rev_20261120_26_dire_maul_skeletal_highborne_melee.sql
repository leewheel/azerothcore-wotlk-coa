-- By leewheel 20261120
-- #13000 厄运之槌：骸骨高阶精灵（11476）的伤害与腐烂高阶精灵对齐
-- 普通难度伤害系数归 1，精英版 211476 归 4.73
-- End By leewheel
UPDATE `creature_template` SET `DamageModifier` = 1 WHERE `entry` = 11476;
UPDATE `creature_template` SET `DamageModifier` = 4.73 WHERE `entry` = 211476;
