CREATE TABLE `spell_jump_distance` (
  `ID` int unsigned NOT NULL COMMENT 'spell id',
  `JumpDistance` float NOT NULL DEFAULT '0' COMMENT 'max hop distance in yards',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Per-spell chain jump distance override';
INSERT INTO `spell_jump_distance` VALUES (62131,5),(64390,5);
