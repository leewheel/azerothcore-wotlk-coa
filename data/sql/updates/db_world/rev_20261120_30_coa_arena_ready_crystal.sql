-- By leewheel 20261120
-- #12998 竞技场：新增「就绪水晶」物件（9900053）
-- 准备阶段点一下即可表态就绪，队伍提示「就绪：x/y」；双方都够人数后把开场倒计时压到 15 秒
-- 中文名走 gameobject_template_locale，主表保留英文原名
-- End By leewheel
INSERT INTO `gameobject_template` (`entry`, `type`, `displayId`, `name`, `size`, `ScriptName`) VALUES
(9900053, 10, 6905, 'Arena Ready Crystal', 2, 'go_coa_arena_ready_crystal') ON DUPLICATE KEY UPDATE `size` = 2;

UPDATE `gameobject_template` SET `type` = 10, `displayId` = 6905, `name` = 'Arena Ready Crystal', `size` = 2,
    `ScriptName` = 'go_coa_arena_ready_crystal' WHERE `entry` = 9900053;

-- 物件中文名
DELETE FROM `gameobject_template_locale` WHERE `entry` = 9900053 AND `locale` = 'zhCN';
INSERT INTO `gameobject_template_locale` (`entry`, `locale`, `name`, `castBarCaption`, `VerifiedBuild`) VALUES
(9900053, 'zhCN', '竞技场就绪水晶', '', 12340);
