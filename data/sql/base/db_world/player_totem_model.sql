CREATE TABLE `player_totem_model` (
  `TotemID` tinyint unsigned NOT NULL,
  `RaceID` tinyint unsigned NOT NULL,
  `ModelID` int unsigned NOT NULL,
  PRIMARY KEY (`TotemID`,`RaceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci PACK_KEYS=0;
INSERT INTO `player_totem_model` VALUES (1,2,30758),(1,3,30754),(1,6,4589),(1,8,30762),(1,11,19074),(2,2,30757),(2,3,30753),(2,6,4588),(2,8,30761),(2,11,19073),(3,2,30759),(3,3,30755),(3,6,4587),(3,8,30763),(3,11,19075),(4,2,30756),(4,3,30736),(4,6,4590),(4,8,30760),(4,11,19071);
