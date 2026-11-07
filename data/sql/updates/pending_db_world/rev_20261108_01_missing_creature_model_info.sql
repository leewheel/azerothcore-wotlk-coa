-- 2026-11-08 补齐 creature_template_model 引用但 creature_model_info 缺失的模型行（By leewheel）
-- 触发：门禁 Errors.log 报 No model data exist for `CreatureDisplayID` = 427586 (Entry 250305)、
--       102253 (Entry 970002)、102250 (Entry 970042)。
-- 取值依据：
--   427586（收割者幽灵镰刀，武器道具模型）沿用旧镰刀模型 25398 的 0.31 / 1 / 2（性别无）。
--   102253、102250（黑市工匠补给商，道具模型）沿用同批 1022xx 模型行（102251/102252/102254）的 1 / 1 / 2。

INSERT INTO `creature_model_info` (`DisplayID`, `BoundingRadius`, `CombatReach`, `Gender`, `DisplayID_Other_Gender`) VALUES
(427586, 0.31, 1, 2, 0),
(102253, 1, 1, 2, 0),
(102250, 1, 1, 2, 0)
ON DUPLICATE KEY UPDATE `BoundingRadius` = VALUES(`BoundingRadius`), `CombatReach` = VALUES(`CombatReach`),
    `Gender` = VALUES(`Gender`), `DisplayID_Other_Gender` = VALUES(`DisplayID_Other_Gender`);
