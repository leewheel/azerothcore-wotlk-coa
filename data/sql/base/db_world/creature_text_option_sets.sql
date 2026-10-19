CREATE TABLE `creature_text_option_sets` (
  `SetID` tinyint unsigned NOT NULL,
  `Cooldown` int unsigned NOT NULL DEFAULT '0' COMMENT 'Group cooldown in ms before it can fire again',
  `TriggerChance` tinyint unsigned NOT NULL DEFAULT '100' COMMENT '0-100 pct chance to fire at all',
  `PlayerOnly` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Only fire if target is a player',
  `comment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`SetID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `creature_text_option_sets` VALUES (1,6000,100,0,'Standard kill yell: 6s cooldown'),(2,6000,100,1,'Player-only kill yell: 6s cooldown'),(3,5000,100,1,'Short cooldown player-only kill yell: 5s cooldown'),(4,0,30,0,'Chance-based: 30% trigger, no cooldown'),(5,5000,100,0,'Standard kill yell: 5s cooldown'),(6,0,25,1,'Chance-based: 25% trigger, player-only'),(7,0,50,1,'Chance-based: 50% trigger, player-only');
