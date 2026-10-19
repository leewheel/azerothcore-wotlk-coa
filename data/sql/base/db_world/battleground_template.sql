CREATE TABLE `battleground_template` (
  `ID` int unsigned NOT NULL DEFAULT '0',
  `MinPlayersPerTeam` smallint unsigned NOT NULL DEFAULT '0',
  `MaxPlayersPerTeam` smallint unsigned NOT NULL DEFAULT '0',
  `MinLvl` tinyint unsigned NOT NULL DEFAULT '0',
  `MaxLvl` tinyint unsigned NOT NULL DEFAULT '0',
  `AllianceStartLoc` int unsigned DEFAULT NULL,
  `AllianceStartO` float NOT NULL,
  `HordeStartLoc` int unsigned DEFAULT NULL,
  `HordeStartO` float NOT NULL,
  `StartMaxDist` float NOT NULL DEFAULT '0',
  `Weight` tinyint unsigned NOT NULL DEFAULT '1',
  `ScriptName` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `Comment` char(38) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `battleground_template` VALUES (1,20,40,51,80,611,3.16312,610,0.715504,100,1,'','Alterac Valley (battleground)'),(2,5,10,10,80,769,3.14159,770,0.151581,75,1,'','Warsong Gulch (battleground)'),(3,8,15,20,80,890,3.91571,889,0.813671,75,1,'','Arathi Basin (battleground)'),(4,0,5,10,80,929,0,936,3.14159,0,1,'','Nagrand Arena / Ring of Trials (arena)'),(5,0,5,10,80,939,0,940,3.14159,0,1,'','Blades\'s Edge Arena (arena)'),(6,0,5,10,80,0,0,0,0,0,1,'','All Arenas (arena)'),(7,8,15,61,80,1103,3.03123,1104,0.055761,10,1,'','Eye of The Storm (battleground)'),(8,0,5,10,80,1258,0,1259,3.14159,0,1,'','Ruins of Lordaeron (arena)'),(9,7,15,71,80,1367,0,1368,0,0,1,'','Strand of the Ancients (battleground)'),(10,0,5,10,80,1362,0,1363,3.14159,0,1,'','Dalaran Sewers (arena)'),(11,0,5,10,80,1364,0,1365,0,0,1,'','The Ring of Valor (arena)'),(30,20,40,71,80,1485,0,1486,3.16124,200,1,'','Isle of Conquest (battleground)'),(32,10,10,80,80,0,0,0,0,0,1,'','Random Battleground (battleground)');
