-- By leewheel 2026年10月26日
-- Errors.log 治理第三轮补充：LoadSpellTalentRanks 报错 First Rank Spell 118778 for TalentEntry 55000 does not exist。
-- Talent.dbc 中天赋 55000（Tab 303 / Tier4 / Col3）引用的一阶法术 118778 已被 COA 从 Spell.dbc 删除（118779 二阶仍存在），
-- 服务端 talent_dbc 表支持按 ID 覆盖 DBC 行：将 118779 提升为该天赋唯一等级，消除一阶缺失报错并保留天赋可用性。
-- 说明：118778 缺失期间玩家无法习得一阶，因而不可能持有二级点数，此覆盖无玩家数据回退风险。
INSERT IGNORE INTO talent_dbc (ID, TabID, TierID, ColumnIndex, SpellRank_1, SpellRank_2, SpellRank_3, SpellRank_4, SpellRank_5, SpellRank_6, SpellRank_7, SpellRank_8, SpellRank_9, PrereqTalent_1, PrereqTalent_2, PrereqTalent_3, PrereqRank_1, PrereqRank_2, PrereqRank_3, Flags, RequiredSpellID, CategoryMask_1, CategoryMask_2)
VALUES (55000, 303, 4, 3, 118779, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
