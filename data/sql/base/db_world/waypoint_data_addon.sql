CREATE TABLE `waypoint_data_addon` (
  `PathID` int unsigned NOT NULL,
  `PointID` int unsigned NOT NULL,
  `SplinePointIndex` int unsigned NOT NULL,
  `PositionX` float NOT NULL DEFAULT '0',
  `PositionY` float NOT NULL DEFAULT '0',
  `PositionZ` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`PathID`,`PointID`,`SplinePointIndex`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
