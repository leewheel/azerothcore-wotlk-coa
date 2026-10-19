CREATE TABLE `spawn_group_template` (
  `groupId` int unsigned NOT NULL,
  `groupName` varchar(100) NOT NULL,
  `groupFlags` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`groupId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO `spawn_group_template` VALUES (0,'Default Group',1),(1,'Legacy Group',3),(100,'Sanctum of the Stars - Defenders',4),(101,'Sanctum of the Stars - Skybreakers',4),(102,'Altar of Sha\'tar - Defenders',4),(103,'Altar of Sha\'tar - Skybreakers',4),(104,'Scarlet Mine - Miner & Mine Car pairs (compatibility respawn)',2);
