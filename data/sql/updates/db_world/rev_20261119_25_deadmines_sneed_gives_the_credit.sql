-- 2026.11.19 死亡矿井：斯尼德本体计入首领进度（上游 #12814 / 议题 #12662）
-- 玩家击杀斯尼德本体（643）才算数，击杀他的伐木机（642）不计首领进度。
-- 新建 coa_mythic_wing_credit 表供模块按 encounter 覆盖计分生物。// By leewheel 20261119
CREATE TABLE IF NOT EXISTS `coa_mythic_wing_credit` (
    `encounter` INT UNSIGNED NOT NULL,
    `creature` INT UNSIGNED NOT NULL,
    `comment` VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY (`encounter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DELETE FROM `coa_mythic_wing_credit` WHERE `encounter` IN (162, 1162, 2162);
INSERT INTO `coa_mythic_wing_credit` (`encounter`, `creature`, `comment`) VALUES
    (162, 643, '死亡矿井 - 斯尼德本体计分，非其伐木机'),
    (1162, 643, '死亡矿井 - 斯尼德本体计分，非其伐木机'),
    (2162, 643, '死亡矿井 - 斯尼德本体计分，非其伐木机');

DELETE FROM `coa_mythic_forces` WHERE `entry` = 642;
INSERT INTO `coa_mythic_forces` (`entry`, `forces`, `comment`) VALUES
    (642, 0, '斯尼德的伐木机 - 首领进度由斯尼德本体提供');

DELETE FROM `coa_dungeon_mark_bosses` WHERE `entry` IN (642, 643);
INSERT INTO `coa_dungeon_mark_bosses` (`entry`) VALUES (643);

UPDATE `instance_encounters` SET `creditEntry` = 643 WHERE `entry` = 1162 AND `creditType` = 0;
