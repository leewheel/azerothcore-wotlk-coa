-- By leewheel 20261120
-- #13012 补回缺失的召唤物模板（七个）
-- 数据取自 CoA 生物缓存数据集 836dab599218015bced50dfb87a5a3b022f745b8636ae86e632e22e0349b1730（2026-11-18）
-- 源文件：cachedata/by-locale/enUS/by-mode/conquest-of-azeroth/creaturecache.tsv.gz
-- 缓存里记录了名称、外观、科系、类型、标志位以及生命与法力系数
-- 阵营、单位职业、攻击节奏和控心者的模型几何沿用核心召唤默认值
-- 必须在 rev_20261003_20_ascension_creature_families.sql 放宽科系字段之后再执行
-- 中文名走 creature_template_locale，主表保留英文原名
-- End By leewheel
START TRANSACTION;

DELETE FROM `creature_model_info` WHERE `DisplayID` = 464978;
INSERT INTO `creature_model_info`
    (`DisplayID`, `BoundingRadius`, `CombatReach`, `Gender`, `DisplayID_Other_Gender`, `VerifiedBuild`)
VALUES (464978, 0.389, 1.5, 2, 0, 12340);

INSERT INTO `creature_template`
    (`entry`, `name`, `faction`, `unit_class`, `BaseAttackTime`, `RangeAttackTime`,
     `family`, `type`, `type_flags`, `HealthModifier`, `ManaModifier`, `VerifiedBuild`)
VALUES
    (50095, 'Faceless Servant', 35, 1, 2000, 2000, 544, 10, 1, 1.0, 1.0, 12340),
    (50308, 'Infinite Protector', 35, 1, 2000, 2000, 550, 2, 1, 1.3, 1.0, 12340),
    (50315, 'Spirit of the Hawk', 35, 1, 2000, 2000, 0, 1, 1, 1.0, 1.0, 12340),
    (50317, 'Spirit of the Turtle', 35, 1, 2000, 2000, 0, 1, 0, 1.1, 1.0, 12340),
    (50318, 'Spirit of the Tiger', 35, 1, 2000, 2000, 0, 1, 1, 1.0, 1.0, 12340),
    (50319, 'Spirit of Earth', 35, 1, 2000, 2000, 0, 1, 1, 1.0, 1.0, 12340),
    (50328, 'Mindbender', 35, 2, 2000, 2000, 553, 12, 0, 1.0, 1.0, 12340)
ON DUPLICATE KEY UPDATE `entry` = `creature_template`.`entry`;

DELETE FROM `creature_template_model`
WHERE `CreatureID` IN (50095, 50308, 50315, 50317, 50318, 50319, 50328) AND `Idx` = 0;
INSERT INTO `creature_template_model`
    (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`)
VALUES
    (50095, 0, 28465, 1, 1, 12340),
    (50308, 0, 20515, 1, 1, 12340),
    (50315, 0, 22633, 1, 1, 12340),
    (50317, 0, 4829, 1, 1, 12340),
    (50318, 0, 11031, 1, 1, 12340),
    (50319, 0, 9589, 1, 1, 12340),
    (50328, 0, 464978, 1, 1, 12340);

-- 召唤：控心者（803062）的客户端提示里引用熵能联结（800022）
DELETE FROM `creature_template_spell` WHERE `CreatureID` = 50328 AND `Index` = 0;
INSERT INTO `creature_template_spell` (`CreatureID`, `Index`, `Spell`, `VerifiedBuild`)
VALUES (50328, 0, 800022, 12340);

-- 七个召唤物的中文名
DELETE FROM `creature_template_locale` WHERE `entry` IN (50095, 50308, 50315, 50317, 50318, 50319, 50328) AND `locale` = 'zhCN';
INSERT INTO `creature_template_locale` (`entry`, `locale`, `Name`, `Title`, `VerifiedBuild`) VALUES
(50095, 'zhCN', '无面者仆从', '', 12340),
(50308, 'zhCN', '永恒守护者', '', 12340),
(50315, 'zhCN', '鹰之精魂', '', 12340),
(50317, 'zhCN', '龟之精魂', '', 12340),
(50318, 'zhCN', '虎之精魂', '', 12340),
(50319, 'zhCN', '大地之精魂', '', 12340),
(50328, 'zhCN', '控心者', '', 12340);

COMMIT;
