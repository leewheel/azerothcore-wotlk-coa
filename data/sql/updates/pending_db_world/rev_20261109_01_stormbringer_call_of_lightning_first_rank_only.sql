-- By leewheel 2026年11月9日
-- #11540 的 spell_group 1172 把 Call of the Lightning 的 Rank 2 / Rank 3（575844、575845）也写了进去。
-- 核心 SpellMgr::LoadSpellGroups 只接受法术链首级，其余一律打
-- "Spell X listed in `spell_group` is not first rank of spell." 并从组里剔除，
-- 每启动一次就是两条 Errors.log 错误。
-- 组里只留首级 575843 与团队形态 575846 即可：判定走 IsSpellMemberOfSpellGroup 的
-- GetFirstRankSpell()->Id，整条等级链照样命中，互斥规则的功能不变。
-- End By leewheel

DELETE FROM `spell_group` WHERE `id` = 1172 AND `spell_id` IN (575844, 575845);
