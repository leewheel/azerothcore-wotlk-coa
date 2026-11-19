-- 2026.11.19 秘境+词缀「群集战术」（法术 80054）关联 80055 修正（上游 #12809）
-- 80054 每层带来 35% 伤害 / 33% 减伤；它关联的 80055 是 10 码友方光环，11% 增伤 / 8% 减伤。
-- 与「部落」词缀一致，光环持有者不再计算自己：五人大队中每名附近队友提供一层，
-- 最多四层（不含自身）。// By leewheel 20261119
DELETE FROM `spell_script_names` WHERE `spell_id` = 80055 AND `ScriptName` = 'spell_coa_mythic_horde';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
    (80055, 'spell_coa_mythic_horde');
