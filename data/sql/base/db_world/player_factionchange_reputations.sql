CREATE TABLE `player_factionchange_reputations` (
  `alliance_id` int unsigned NOT NULL,
  `alliance_comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `horde_id` int unsigned NOT NULL,
  `horde_comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`alliance_id`,`horde_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `player_factionchange_reputations` VALUES (47,'Ironforge',530,'Darkspear Trolls'),(54,'Gnomeregan Exiles',81,'Thunder Bluff'),(69,'Darnassus',68,'Undercity'),(72,'Stormwind',76,'Orgrimmar'),(509,'The League of Arathor',510,'The Defilers'),(730,'Stormpike Guard',729,'Frostwolf Clan'),(890,'Silverwing Sentinels',889,'Warsong Outriders'),(930,'Exodar',911,'Silvermoon City'),(946,'Honor Hold',947,'Thrallmar'),(978,'Kurenai',941,'The Mag\'har'),(1037,'Alliance Vanguard',1052,'Horde Expedition'),(1050,'Valiance Expedition',1085,'Warsong Offensive'),(1068,'Explorers\' League',1064,'The Taunka'),(1094,'The Silver Covenant',1124,'The Sunreavers'),(1126,'The Frostborn',1067,'The Hand of Vengeance');
