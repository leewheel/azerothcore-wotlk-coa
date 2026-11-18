-- 2026.11.19 门禁错误修复（两类，均来自历史脏数据被本轮新数据放大）
-- By leewheel 20261119
--
-- 问题一：Errors.log 报 "No model data exist for CreatureDisplayID = X listed by creature"
--   出处：ObjectMgr::GetCreatureModelInfo 查 creature_model_info 表，表里缺这些 display 的行。
--   已核实客户端 CreatureDisplayInfo.dbc 与 CreatureModelData.dbc 都有这些 display 及其模型，
--   所以只是建模表缺行，补齐即可（数值取物件/法术特效的常规值 1.0/1.0，无性别）。
--   涉及：255536~255539（达拉然守护石，hillsbrad）、9417032/9417066/9417068/9417069/9417070/9417071（智慧球特效）。
--
-- 问题二：SmartAIMgr 报 "using non-existent Text id"，entry 为负 9950xxx。
--   出处：smart_scripts 里 -9950702~-9950727 这批动作列表引用了 creature_text 的组，
--   但对应生物 9950xxx 在 creature_template 里根本不存在（99xxxxx 段 0 个生物），
--   这些脚本永远不会被触发，属历史脏数据；清掉，避免每次启动刷 35 条错误。

INSERT INTO `creature_model_info`
(`DisplayID`, `BoundingRadius`, `CombatReach`, `Gender`, `DisplayID_Other_Gender`, `VerifiedBuild`) VALUES
(354000, 1.0, 1.0, 2, 0, 0),
(133550, 1.0, 1.0, 2, 0, 0),
(460984, 1.0, 1.0, 2, 0, 0),
(130744, 1.0, 1.0, 2, 0, 0),
(130743, 1.0, 1.0, 2, 0, 0),
(460930, 1.0, 1.0, 2, 0, 0),
(460931, 1.0, 1.0, 2, 0, 0)
ON DUPLICATE KEY UPDATE
    `BoundingRadius` = VALUES(`BoundingRadius`),
    `CombatReach` = VALUES(`CombatReach`),
    `Gender` = VALUES(`Gender`);

DELETE `s` FROM `smart_scripts` `s`
WHERE `s`.`entryorguid` < 0
  AND `s`.`entryorguid` BETWEEN -9960000 AND -9900000
  AND NOT EXISTS (SELECT 1 FROM `creature_template` `c` WHERE `c`.`entry` = -`s`.`entryorguid`);
-- End By leewheel
