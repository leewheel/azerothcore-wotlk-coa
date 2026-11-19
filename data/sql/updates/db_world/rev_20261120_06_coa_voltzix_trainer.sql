-- 2026.11.20 沃尔提克斯·斯普罗克特波普（议题 #12752）在 WDB 数据里是十字路口的工程学训练师，但此前只提供任务。
-- 上游 #12817（世界任务批次 9）。// By leewheel 20261120
UPDATE `creature_template` SET `npcflag` = 83, `gossip_menu_id` = 9010711 WHERE `entry` = 753524;

DELETE FROM `gossip_menu_option` WHERE `MenuID` = 9010711 AND `OptionID` = 0;
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`,
    `OptionType`, `OptionNpcFlag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`,
    `BoxBroadcastTextID`, `VerifiedBuild`) VALUES
(9010711, 0, 3, 'Train me.', 3266, 5, 16, 0, 0, 0, 0, '', 0, 0);

DELETE FROM `creature_default_trainer` WHERE `CreatureId` = 753524;
INSERT INTO `creature_default_trainer` (`CreatureId`, `TrainerId`) VALUES
(753524, 92);
