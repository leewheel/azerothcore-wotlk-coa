-- 2026.11.20 机器人 3.1.6：记录用 SquidBots 插件「静音」按钮静音了自己所有机器人的真人玩家
-- （一次静音全部小号与招募机器人，跨会话保留）。player 是角色 guid。被静音的机器人仍会回应指令。
-- 上游 mod-playerbots 2026_11_19_02（CoA Bots 3.1.6）。// By leewheel 20261120
CREATE TABLE IF NOT EXISTS `playerbots_coa_mute` (
    `player` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`player`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
