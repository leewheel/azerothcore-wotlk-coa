-- By leewheel 20261115
-- 说明：以下两处不是玩法改动，而是修掉会让 worldserver 启动日志报错的数据库问题。
-- 1) 祖尔格拉布蜘蛛卵生物（14915 及 114915/214915/314915 三个难度）使用显示 80019，
--    但 creature_model_info 表缺 80019 这一行，启动时每条模板都会报
--    "No model data exist for CreatureDisplayID = 80019 listed by creature"。
--    该显示在同族的 80018 / 80020 之间，身材数值与二者完全一致，按同族补齐。
-- 2) spell_proc 681311（工匠·烈焰铸泰坦的触发光环）HitMask 写了 32767(0x7FFF)，
--    超出 PROC_HIT_MASK_ALL(0x2FFF)，启动报 "wrong HitMask set"。
--    收敛到 0x2FFF 后仍然是「任何命中都触发」，实际行为不变。
-- End By leewheel

DELETE FROM `creature_model_info` WHERE `DisplayID` = 80019;
INSERT INTO `creature_model_info` (`DisplayID`, `BoundingRadius`, `CombatReach`, `Gender`, `DisplayID_Other_Gender`, `VerifiedBuild`) VALUES
(80019, 0.306, 1.5, 0, 0, 0);

UPDATE `spell_proc` SET `HitMask` = 0x2FFF WHERE `SpellId` = 681311 AND `HitMask` = 0x7FFF;
