-- 补 active_arena_season 默认行，避免空表导致 worldserver 启动断言失败
-- 仅在表完全为空时插入，绝不覆盖玩家已有的赛季进度
-- By leewheel 20261119

INSERT INTO `active_arena_season` (`season_id`, `season_state`)
SELECT 8, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `active_arena_season`);
