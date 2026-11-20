-- 2026.11.20 机器人 3.1.6：在「自力更生」国度（AiPlayerbot.CoaSelfFound = 1）里，
-- 当随机机器人身上一件武器都没有时，一次性发给它本职业的起始武器（AiPlayerbot.CoaSelfFound.StarterWeapon）。
-- bot 是角色 guid：登记在这里的机器人终身不会再领第二次，卖掉或销毁也不会补发。
-- 上游 mod-playerbots 2026_11_19_03（CoA Bots 3.1.6）。// By leewheel 20261120
CREATE TABLE IF NOT EXISTS `playerbots_coa_starter_weapon` (
    `bot`  INT UNSIGNED NOT NULL,
    `item` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`bot`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
