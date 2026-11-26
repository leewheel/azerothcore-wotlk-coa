-- By leewheel 2026年11月26日
-- Errors.log 治理：本轮上游合并 + 参考项目引入后的三处启动告警
-- 1) spell_proc 无效掩码清零：ProcFlags = 0x28 不含相位位，掩码不生效（校验在 SpellMgr.cpp），清零不改变游戏行为
-- 2) creature_model_info 补 4 个 display 行：GetCreatureModelInfo 查不到会写 Errors.log，该表只用于碰撞体积，补默认值不改变外观
-- 3) item_loot_template 1615011 补回 978064 行：conditions 已有 5 组 ElseGroup 条件指向 978064，但战利品行缺失，导致孤儿条件与 "not found in LootTemplate" 告警

-- 1) SpellPhaseMask 无效：清 0
UPDATE `spell_proc` SET `SpellPhaseMask` = 0 WHERE `SpellId` IN
(201178, 312480, 316480, 320480);

-- 2) 缺失的 creature_model_info 行（0.306 / 1.5 为本表最常见的通用取值）
DELETE FROM `creature_model_info` WHERE `DisplayID` IN (92610, 228465, 454000, 31792);
INSERT INTO `creature_model_info`
(`DisplayID`, `BoundingRadius`, `CombatReach`, `Gender`, `DisplayID_Other_Gender`, `VerifiedBuild`) VALUES
(92610, 0.306, 1.5, 0, 0, 0),
(228465, 0.306, 1.5, 0, 0, 0),
(454000, 0.306, 1.5, 0, 0, 0),
(31792, 0.306, 1.5, 0, 0, 0);

-- 3) 1615011 战利品箱补回 978064（Valorous Redemption Faceguard）
-- 条件端已限制为持有 20121 达 3/4/5/6/7/8 件的 ElseGroup，故此处按必得配置
DELETE FROM `item_loot_template` WHERE `Entry` = 1615011 AND `Item` = 978064;
INSERT INTO `item_loot_template`
(`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`) VALUES
(1615011, 978064, 0, 100, 0, 1, 0, 1, 1, '');
-- End By leewheel 2026年11月26日
