-- COA 物品名中文化（最终收口批次）//By leewheel 2026年10月30日
-- Old Gods 系列等真实可见物品，剩余均为开发占位/美术资源件
-- entry 27 个

SET NAMES 'utf8mb4';

INSERT INTO `item_template_locale` (`ID`,`locale`,`Name`,`Description`) VALUES
(11328, 'zhCN', '古神的指引', NULL),
(15832, 'zhCN', '不可获得的古神祝福', NULL),
(107708, 'zhCN', '暗影潜行之匕', NULL),
(132600, 'zhCN', '世界铸卷：古神之跃', NULL),
(200587, 'zhCN', '秘法卷轴：虚空先驱：古神之疯狂', NULL),
(201033, 'zhCN', '秘法卷轴：古神之跃', NULL),
(202415, 'zhCN', '秘法卷轴：古神仆从', NULL),
(211328, 'zhCN', '古神的指引', NULL),
(311328, 'zhCN', '古神的指引', NULL),
(521197, 'zhCN', '塔卡尔的旧魔杖', NULL),
(525418, 'zhCN', '被附身的古神套装宝箱', NULL),
(525478, 'zhCN', '恐怖的古神套装宝箱', NULL),
(559100, 'zhCN', '善良老退休者的报酬', NULL),
(559102, 'zhCN', '善良老退休者的钱袋', NULL),
(1311328, 'zhCN', '古神的指引', NULL),
(1379789, 'zhCN', '塔卡尔的旧魔杖', NULL),
(1381789, 'zhCN', '塔卡尔的旧魔杖', NULL),
(1383789, 'zhCN', '塔卡尔的旧魔杖', NULL),
(1385789, 'zhCN', '塔卡尔的旧魔杖', NULL),
(1387789, 'zhCN', '塔卡尔的旧魔杖', NULL),
(1389303, 'zhCN', '塔卡尔的旧魔杖', NULL),
(1393789, 'zhCN', '塔卡尔的旧魔杖', NULL),
(2072101, 'zhCN', '古神低语裹手', NULL),
(2075093, 'zhCN', '古神脉动法杖', NULL),
(2205293, 'zhCN', '技能卡：古神仆从', NULL),
(2205294, 'zhCN', '金色技能卡：古神仆从', NULL),
(6038683, 'zhCN', '血铸·暗黑骑士的过时徽记（旧）', NULL)
ON DUPLICATE KEY UPDATE `Name` = VALUES(`Name`);

-- 结束：27 条
