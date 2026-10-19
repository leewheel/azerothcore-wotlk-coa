CREATE TABLE `arena_season_reward_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `arena_season` tinyint unsigned NOT NULL,
  `criteria_type` enum('pct','abs') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pct' COMMENT 'Determines how rankings are evaluated: "pct" - percentage-based (e.g., top 20% of the ladder), "abs" - absolute position-based (e.g., top 10 players).',
  `min_criteria` float NOT NULL,
  `max_criteria` float NOT NULL,
  `reward_mail_template_id` int unsigned DEFAULT NULL,
  `reward_mail_subject` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reward_mail_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `gold_reward` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `arena_season_reward_group` VALUES (1,8,'abs',1,1,0,'','',0),(2,8,'pct',0,0.5,287,'','',0),(3,8,'pct',0.5,3,0,'','',0),(4,8,'pct',3,10,0,'','',0),(5,8,'pct',10,35,0,'','',0),(6,7,'abs',1,1,0,'','',0),(7,7,'pct',0,0.5,286,'','',0),(8,7,'pct',0.5,3,0,'','',0),(9,7,'pct',3,10,0,'','',0),(10,7,'pct',10,35,0,'','',0),(11,6,'abs',1,1,0,'','',0),(12,6,'pct',0,0.5,267,'','',0),(13,6,'pct',0.5,3,0,'','',0),(14,6,'pct',3,10,0,'','',0),(15,6,'pct',10,35,0,'','',0),(16,5,'abs',1,1,0,'','',0),(17,5,'pct',0,0.5,266,'','',0),(18,5,'pct',0.5,3,0,'','',0),(19,5,'pct',3,10,0,'','',0),(20,5,'pct',10,35,0,'','',0),(21,4,'abs',1,1,0,'','',0),(22,4,'pct',0,0.5,262,'','',0),(23,4,'pct',0.5,3,0,'','',0),(24,4,'pct',3,10,0,'','',0),(25,4,'pct',10,35,0,'','',0),(26,3,'abs',1,1,0,'','',0),(27,3,'pct',0,0.5,211,'','',0),(28,3,'pct',0.5,3,0,'','',0),(29,3,'pct',3,10,0,'','',0),(30,3,'pct',10,35,0,'','',0),(31,2,'abs',1,1,0,'','',0),(32,2,'pct',0,0.5,0,'Congratulations!','On behalf of the Steamwheedle Fighting Circuit, we congratulate you for your successes in this arena season.$B$BIn recognition of your skill and savagery, we hereby bestow upon you this Merciless Nether Drake.  May it serve you well.',0),(33,2,'pct',0.5,3,0,'','',0),(34,2,'pct',3,10,0,'','',0),(35,2,'pct',10,35,0,'','',0),(36,1,'pct',0,0.5,0,'Congratulations!','On behalf of the Steamwheedle Fighting Circuit, we congratulate you for your successes in this arena season.$B$BIn recognition of your skill and savagery, we hereby bestow upon you this Swift Nether Drake.  May it serve you well.',0),(37,1,'pct',0.5,3,0,'','',0),(38,1,'pct',3,10,0,'','',0),(39,1,'pct',10,35,0,'','',0);
