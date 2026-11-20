-- By leewheel 20261120
-- #13003 黑石深渊：高阶审讯官格斯塔恩改为每 10 秒施放一次法力燃烧
-- 从首领套牌里移除原来的 14033 条目，改由脚本按固定 10 秒节奏施放，避免旧套牌重复触发
-- End By leewheel
DELETE FROM `coa_dungeon_boss_kit` WHERE `entry` = 9018 AND `id` = 1 AND `spell` = 14033;
