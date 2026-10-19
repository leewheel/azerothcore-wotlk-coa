CREATE TABLE `ascension_custom_class` (
  `class` tinyint unsigned NOT NULL,
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `client_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fallback_class` tinyint unsigned NOT NULL,
  `power_type` tinyint unsigned NOT NULL,
  `primary_stat` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`class`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `ascension_custom_class` VALUES (12,'Barbarian','Barbarian',4,3,'Agility'),(13,'Witch Doctor','Witch Doctor',7,0,'Intellect'),(14,'Demon Hunter','Felsworn',4,3,'Agility'),(15,'Witch Hunter','Witch Hunter',3,0,'Agility'),(16,'Stormbringer','Stormbringer',7,0,'Intellect'),(17,'Fleshwarden','Knight of Xoroth',1,1,'Strength'),(18,'Guardian','Guardian',1,3,'Strength'),(19,'Monk','Templar',4,3,'Agility'),(20,'Son of Arugal','Bloodmage',11,1,'Agility'),(21,'Ranger','Ranger',3,2,'Agility'),(22,'Chronomancer','Chronomancer',5,0,'Spirit'),(23,'Necromancer','Necromancer',9,6,'Intellect'),(24,'Pyromancer','Pyromancer',8,0,'Intellect'),(25,'Cultist','Cultist',2,0,'Strength'),(26,'Starcaller','Starcaller',11,3,'Intellect'),(27,'Sun Cleric','Sun Cleric',5,0,'Intellect'),(28,'Tinker','Tinker',3,0,'Agility'),(29,'Prophet','Venomancer',7,0,'Intellect'),(30,'Reaper','Reaper',4,6,'Agility'),(31,'Wildwalker','Primalist',11,0,'Agility'),(32,'Spirit Mage','Runemaster',7,0,'Intellect');
