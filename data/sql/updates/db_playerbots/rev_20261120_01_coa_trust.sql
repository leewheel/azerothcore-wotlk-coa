-- 2026.11.20 机器人 3.1.6：记录每个真人玩家对他每只机器人（小号或招募的）的「信任度」，
-- 在 SquidBots 插件信息页显示为等级与进度条。一起杀怪会增长，杀首领长得更多。
-- player 与 bot 都是角色 guid。此表只用于显示：任何等级都不解锁也不限制什么。
-- 上游 mod-playerbots 2026_11_19_01（CoA Bots 3.1.6）。// By leewheel 20261120
CREATE TABLE IF NOT EXISTS `playerbots_coa_trust` (
    `player` INT UNSIGNED NOT NULL,
    `bot`    INT UNSIGNED NOT NULL,
    `score`  INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`player`, `bot`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
