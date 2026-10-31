-- 门禁 Errors.log 数据修复（2026-10-31）By leewheel
-- 1) spell_proc 1131641/1131642（Reborn Blazing Speed，ProcFlags=0x28 TAKEN 近战）：
--    TAKEN 触发不走 SpellPhaseMask（仅 DONE 命中位 REQ_SPELL_PHASE_PROC_FLAG_MASK 才读），清零消警告，行为不变。
-- 2) spell_proc 1470375-1470379（训练师命令圣印，ProcFlags=0x4 近战自动攻击）：
--    近战自动攻击不在 SPELL_PROC_FLAG_MASK/PERIODIC 掩码内，SpellTypeMask/SpellPhaseMask 均不被核心读取，清零消警告，行为不变。
-- 3) creature_formations：Paragon 编队 dist/angle 需要 FOLLOW_LEADER(0x200) 旗才生效，补旗启用跟随站位。
-- 4) creature_model_info：Paragon 三个巨魔显示 ID（客户端 DBC 已有，模型表漏插），按同类巨魔参数补行。

UPDATE `spell_proc` SET `SpellPhaseMask` = 0 WHERE `SpellId` IN (1131641, 1131642);
UPDATE `spell_proc` SET `SpellTypeMask` = 0, `SpellPhaseMask` = 0 WHERE `SpellId` IN (1470375, 1470376, 1470377, 1470378, 1470379);

UPDATE `creature_formations` SET `groupAI` = `groupAI` | 0x200
WHERE `memberGUID` IN (2541680, 2541681, 2541682, 2541684, 2541685, 2541686);

DELETE FROM `creature_model_info` WHERE `DisplayID` IN (254026, 254027, 254028);
INSERT INTO `creature_model_info` (`DisplayID`, `BoundingRadius`, `CombatReach`, `Gender`, `DisplayID_Other_Gender`, `VerifiedBuild`) VALUES
(254026, 0.306, 1.5, 0, 0, 12340),
(254027, 0.306, 1.5, 0, 0, 12340),
(254028, 0.306, 1.5, 0, 0, 12340);
