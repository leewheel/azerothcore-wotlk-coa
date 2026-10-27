-- LFG entrance backfill: give COA custom maps a lfg_dungeon_template position so LFGMgr stops
-- failing with "cant find areatrigger" and locking those dungeons (LFGMgr::LoadLFGDungeons).
-- Coordinates sourced from existing game_tele entries (verified in acore_world):
--   map 535  Naxxramas            <- game_tele 10002 "Naxxramas_535"
--   map 889  Korrim Snowgrave(PvE) <- game_tele 10282 "FrostgiantnPVE"
--   map 890  Atal'Zul              <- game_tele 10283 "AtalzulPVE"
--   map 908  The Frozen Reach      <- game_tele 10082 "KaukiVillage"
-- Maps 645 / 1781 / 1912 have no entrance data anywhere (game_tele, creature, gameobject,
-- smart_scripts, spell_target_position, coa-world baseline all empty) and stay locked on purpose.
-- By leewheel 2026年10月27日
DELETE FROM `lfg_dungeon_template` WHERE `dungeonId` IN (597,598,599,600,3314,3315,3316,3317,890,10010,11010,12010,13010,2009,2010,2011);
INSERT INTO `lfg_dungeon_template` (`dungeonId`, `name`, `position_x`, `position_y`, `position_z`, `orientation`, `VerifiedBuild`) VALUES
(597,'Naxxramas',3216.67,-4283.33,355.82,0,0),
(598,'Naxxramas (Heroic)',3216.67,-4283.33,355.82,0,0),
(599,'Naxxramas (25)',3216.67,-4283.33,355.82,0,0),
(600,'Naxxramas (25 Heroic)',3216.67,-4283.33,355.82,0,0),
(3314,'Korrim Snowgrave (PvE)',4750.71,-4942.45,696.7,0.9621,0),
(3315,'Korrim Snowgrave (PvE) Heroic',4750.71,-4942.45,696.7,0.9621,0),
(3316,'Korrim Snowgrave (PvE) 25',4750.71,-4942.45,696.7,0.9621,0),
(3317,'Korrim Snowgrave (PvE) 25 Heroic',4750.71,-4942.45,696.7,0.9621,0),
(890,"Atal'Zul",3317.79,-4859.58,167.36,5.4585,0),
(10010,"Atal'Zul (PvE)",3317.79,-4859.58,167.36,5.4585,0),
(11010,"Atal'Zul (PvE) Heroic",3317.79,-4859.58,167.36,5.4585,0),
(12010,"Atal'Zul (PvE) 25",3317.79,-4859.58,167.36,5.4585,0),
(13010,"Atal'Zul (PvE) 25 Heroic",3317.79,-4859.58,167.36,5.4585,0),
(2009,'The Frozen Reach',2252.51,2398.34,110.4,4.2519,0),
(2010,'The Frozen Reach (Heroic)',2252.51,2398.34,110.4,4.2519,0),
(2011,'The Frozen Reach (25)',2252.51,2398.34,110.4,4.2519,0);
