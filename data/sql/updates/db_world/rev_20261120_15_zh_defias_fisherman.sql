-- 2026.11.20 西部荒野「迪菲亚渔夫」（生物 35913）中文名补全
-- 上游 rev_20261120_01_coa_westfall_defias_fisherman 新增生物只有英文名，补 zhCN。// By leewheel 20261120
DELETE FROM `creature_template_locale` WHERE `locale` = 'zhCN' AND `entry` = 35913;
INSERT INTO `creature_template_locale` (`entry`, `locale`, `Name`, `VerifiedBuild`) VALUES
(35913, 'zhCN', '迪菲亚渔夫', 0);
