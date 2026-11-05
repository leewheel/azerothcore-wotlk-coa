-- 上游 2026-11-05 合并（Blackrock Caverns 等）带来的门禁数据修复：
-- 1) 难度模式模板不应填 ScriptName（核心只用难度 0 模板的脚本），清空 25 条；
-- 2) 两个缺失模型的显示 ID 补 creature_model_info；
-- 3) 5 个法术在客户端 DBC 里不是持续伤害光环，与 spell_coa_brc_damage 的成对 AuraScript 不匹配，移除其绑定；
-- 4) 起始点传送门的四元数不是单位四元数，改为 (0,0,0,1)。
-- By leewheel 2026年11月06日

UPDATE `creature_template` SET `ScriptName` = ''
WHERE `entry` IN (140817,139982,150376,150284,140447,140084,140023,140021,140019,140017,140015,
                  140011,140008,139994,139990,139987,139985,139980,139978,139708,139705,139700,
                  139698,139679,139665)
  AND `ScriptName` <> '';

INSERT INTO `creature_model_info` (`DisplayID`,`BoundingRadius`,`CombatReach`,`Gender`,`DisplayID_Other_Gender`,`VerifiedBuild`) VALUES
(300003,0.306,1.5,0,0,0),
(237285,0.306,1.5,0,0,0)
ON DUPLICATE KEY UPDATE `BoundingRadius`=VALUES(`BoundingRadius`),`CombatReach`=VALUES(`CombatReach`);

DELETE FROM `spell_script_names`
WHERE `spell_id` IN (5011028,5011063,5011064,5011089,5011103)
  AND `ScriptName` = 'spell_coa_brc_damage';

UPDATE `gameobject` SET `rotation0` = 0, `rotation1` = 0, `rotation2` = 0, `rotation3` = 1
WHERE `guid` = 9780102 AND `id` = 380138;

-- End By leewheel
