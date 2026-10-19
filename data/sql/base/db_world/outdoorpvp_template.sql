CREATE TABLE `outdoorpvp_template` (
  `TypeId` tinyint unsigned NOT NULL,
  `ScriptName` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`TypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='OutdoorPvP Templates';
INSERT INTO `outdoorpvp_template` VALUES (1,'outdoorpvp_hp','Hellfire Peninsula'),(2,'outdoorpvp_na','Nagrand'),(3,'outdoorpvp_tf','Terokkar Forest'),(4,'outdoorpvp_zm','Zangarmarsh'),(5,'outdoorpvp_si','Silithus'),(6,'outdoorpvp_ep','Eastern Plaguelands'),(7,'outdoorpvp_gh','Grizzly Hills');
