CREATE TABLE `light_dbc` (
  `ID` int NOT NULL DEFAULT '0',
  `ContinentID` int NOT NULL DEFAULT '0',
  `X` float NOT NULL DEFAULT '0',
  `Y` float NOT NULL DEFAULT '0',
  `Z` float NOT NULL DEFAULT '0',
  `FalloffStart` float NOT NULL DEFAULT '0',
  `FalloffEnd` float NOT NULL DEFAULT '0',
  `LightParamsID_1` int NOT NULL DEFAULT '0',
  `LightParamsID_2` int NOT NULL DEFAULT '0',
  `LightParamsID_3` int NOT NULL DEFAULT '0',
  `LightParamsID_4` int NOT NULL DEFAULT '0',
  `LightParamsID_5` int NOT NULL DEFAULT '0',
  `LightParamsID_6` int NOT NULL DEFAULT '0',
  `LightParamsID_7` int NOT NULL DEFAULT '0',
  `LightParamsID_8` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
