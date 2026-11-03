-- Zone 10115（COA 新版 AreaTable 里的 Blackrock Mountain）在 graveyard_zone 表里没有任何墓地记录，
-- 有角色（含机器人）在该区域死亡时核心会报
-- "Table `graveyard_zone` incomplete: Zone 10115 Team 0 does not have a linked graveyard."。
-- 旧 zone 25（同一片 Blackrock Mountain）用的就是墓地 1469，这里给 10115 补上同一条，行为与旧 zone 一致。
-- By leewheel 2026年11月3日
DELETE FROM `graveyard_zone` WHERE `GhostZone` = 10115;
INSERT INTO `graveyard_zone` (`ID`, `GhostZone`, `Faction`, `Comment`) VALUES
    (1469, 10115, 0, 'Burning Steppes, Blackrock Mountain - Blackrock Mountain');
-- End By leewheel
