CREATE TABLE `itemextendedcost_dbc` (
  `ID` int NOT NULL DEFAULT '0',
  `HonorPoints` int NOT NULL DEFAULT '0',
  `ArenaPoints` int NOT NULL DEFAULT '0',
  `ArenaBracket` int NOT NULL DEFAULT '0',
  `ItemID_1` int NOT NULL DEFAULT '0',
  `ItemID_2` int NOT NULL DEFAULT '0',
  `ItemID_3` int NOT NULL DEFAULT '0',
  `ItemID_4` int NOT NULL DEFAULT '0',
  `ItemID_5` int NOT NULL DEFAULT '0',
  `ItemCount_1` int NOT NULL DEFAULT '0',
  `ItemCount_2` int NOT NULL DEFAULT '0',
  `ItemCount_3` int NOT NULL DEFAULT '0',
  `ItemCount_4` int NOT NULL DEFAULT '0',
  `ItemCount_5` int NOT NULL DEFAULT '0',
  `RequiredArenaRating` int NOT NULL DEFAULT '0',
  `ItemPurchaseGroup` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
