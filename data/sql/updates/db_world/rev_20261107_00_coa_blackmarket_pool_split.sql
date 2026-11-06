-- 黑市工匠补给商人池（970000）里同时有东部王国（map 0）和卡利姆多（map 1）的生物，
-- 核心不支持跨地图的 pool_creature，启动时会跳过并刷 Errors.log。
-- 这里按大陆拆成两个池：970000 = 东部王国，970001 = 卡利姆多，各自每小时随机 3 个。
-- By leewheel 2026年11月07日
INSERT INTO `pool_template` (`entry`, `max_limit`, `description`) VALUES
(970000, 3, 'Blackmarket Artisan Supplies - Eastern Kingdoms'),
(970001, 3, 'Blackmarket Artisan Supplies - Kalimdor')
ON DUPLICATE KEY UPDATE `max_limit` = VALUES(`max_limit`), `description` = VALUES(`description`);

UPDATE `pool_creature` pc
JOIN `creature` c ON c.`guid` = pc.`guid`
SET pc.`pool_entry` = 970001
WHERE pc.`pool_entry` = 970000 AND c.`map` = 1;
-- End By leewheel
