CREATE TABLE `player_loot_template` (
  `Entry` int unsigned NOT NULL DEFAULT '0',
  `Item` int unsigned NOT NULL DEFAULT '0',
  `Reference` int NOT NULL DEFAULT '0',
  `Chance` float NOT NULL DEFAULT '100',
  `QuestRequired` tinyint NOT NULL DEFAULT '0',
  `LootMode` smallint unsigned NOT NULL DEFAULT '1',
  `GroupId` tinyint unsigned NOT NULL DEFAULT '0',
  `MinCount` tinyint unsigned NOT NULL DEFAULT '1',
  `MaxCount` tinyint unsigned NOT NULL DEFAULT '1',
  `Comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`Entry`,`Item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Loot System';
INSERT INTO `player_loot_template` VALUES (0,17422,0,85,0,1,0,15,22,'Alterac Valley - Horde - Armor Scraps'),(0,17423,0,50,0,1,0,2,5,'Alterac Valley - Horde - Storm Crystal'),(0,17502,0,30,0,1,0,1,1,'Alterac Valley - Horde - Frostwolf Soldiers Medal'),(0,17503,0,20,0,1,0,1,1,'Alterac Valley - Horde - Frostwolf Lieutenants Medal'),(0,17504,0,10,0,1,0,1,1,'Alterac Valley - Horde - Frostwolf Commander\'s Medal'),(0,18228,0,1,0,1,0,1,1,'Alterac Valley - Horde - Autographed Picture of Foror & Tigule'),(0,43314,0,100,1,1,0,5,5,'Wintergrasp - Alliance - Eternal Ember'),(0,43323,0,100,1,1,0,5,5,'Wintergrasp - Alliance - Quiver of Dragonbone Arrows'),(0,44808,0,100,1,1,0,5,5,'Wintergrasp - Alliance - Imbued Horde Armor'),(0,44809,0,100,1,1,0,5,5,'Wintergrasp - Alliance - Horde Herb Pouch'),(1,17306,0,50,0,1,0,2,5,'Alterac Valley - Alliance - Stormpike Soldiers Blood'),(1,17326,0,30,0,1,0,1,1,'Alterac Valley - Alliance - Stormpike Soldiers Flesh'),(1,17327,0,20,0,1,0,1,1,'Alterac Valley - Alliance - Stormpike Lieutenants Flesh'),(1,17328,0,10,0,1,0,1,1,'Alterac Valley - Alliance - Stormpike Commander\'s Flesh'),(1,17422,0,85,0,1,0,15,22,'Alterac Valley - Alliance - Armor Scrapts'),(1,18228,0,1,0,1,0,1,1,'Alterac Valley - Alliance - Autographed Picture of Foror & Tigule'),(1,43314,0,100,1,1,0,5,5,'Wintergrasp - Horde - Eternal Ember'),(1,43322,0,100,1,1,0,5,5,'Wintergrasp - Horde - Enchanted Alliance Breastplates'),(1,43323,0,100,1,1,0,5,5,'Wintergrasp - Horde - Quiver of Dragonbone Arrows'),(1,43324,0,100,1,1,0,5,5,'Wintergrasp - Horde - Alliance Herb Pouch');
