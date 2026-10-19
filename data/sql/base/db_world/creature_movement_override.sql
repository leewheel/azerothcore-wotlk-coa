CREATE TABLE `creature_movement_override` (
  `SpawnId` int unsigned NOT NULL DEFAULT '0',
  `Ground` tinyint unsigned DEFAULT NULL,
  `Swim` tinyint unsigned DEFAULT NULL,
  `Flight` tinyint unsigned DEFAULT NULL,
  `Rooted` tinyint unsigned DEFAULT NULL,
  `Chase` tinyint unsigned DEFAULT NULL,
  `Random` tinyint unsigned DEFAULT NULL,
  `InteractionPauseTimer` int unsigned DEFAULT NULL COMMENT 'Time (in milliseconds) during which creature will not move after interaction with player',
  PRIMARY KEY (`SpawnId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `creature_movement_override` VALUES (106339,1,1,2,0,0,0,NULL),(106340,1,1,2,0,0,0,NULL),(117664,1,0,1,0,0,0,NULL),(117670,1,0,1,0,0,0,NULL),(117671,1,0,1,0,0,0,NULL),(117672,1,0,1,0,0,0,NULL),(117677,1,0,1,0,0,0,NULL),(125724,1,1,2,0,0,0,NULL),(130896,1,0,1,0,0,0,NULL),(1971380,1,1,2,0,0,0,NULL);
