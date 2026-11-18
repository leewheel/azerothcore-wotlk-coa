-- 2026.11.19 希尔斯布莱德物件名汉化（gameobject_template_locale）
-- 上游 rev_20261027_84_coa_hillsbrad_restore 新插入物件只有英文名，补 zhCN。By leewheel 20261119
DELETE FROM `gameobject_template_locale` WHERE `locale` = 'zhCN' AND `entry` IN (10007,10009,255065,255066,255067,255068,255069,255070,255071,255072,255073,255080,255081,1000026,1000027,1000028);
INSERT INTO `gameobject_template_locale` (`entry`, `locale`, `name`, `VerifiedBuild`) VALUES
(10007, 'zhCN', '鱼桶', 0),
(10009, 'zhCN', '辛迪加补给箱', 0),
(255065, 'zhCN', '巨魔遗物', 0),
(255066, 'zhCN', '希尔斯布莱德瀑布', 0),
(255067, 'zhCN', '希尔斯布莱德海域', 0),
(255068, 'zhCN', '瘟疫瀑布', 0),
(255069, 'zhCN', '巨魔遗物', 0),
(255070, 'zhCN', '巨魔遗物', 0),
(255071, 'zhCN', '暴食者', 0),
(255072, 'zhCN', '吞食者', 0),
(255073, 'zhCN', '塔伦米尔墓地', 0),
(255080, 'zhCN', '碎石堆', 0),
(255081, 'zhCN', '达拉然火山口结界', 0),
(1000026, 'zhCN', '塔伦贝尔花', 0),
(1000027, 'zhCN', '隐藏祭坛', 0),
(1000028, 'zhCN', '碧玉矿洞银箱', 0);
-- End By leewheel
