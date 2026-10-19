CREATE TABLE `game_event_pool` (
  `eventEntry` smallint NOT NULL COMMENT 'Entry of the game event. Put negative entry to remove during event.',
  `pool_entry` int unsigned NOT NULL DEFAULT '0' COMMENT 'Id of the pool',
  PRIMARY KEY (`pool_entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `game_event_pool` VALUES (9,5699),(9,5700),(9,5701),(9,5702),(9,5703),(9,5704),(9,5705),(9,5706);
