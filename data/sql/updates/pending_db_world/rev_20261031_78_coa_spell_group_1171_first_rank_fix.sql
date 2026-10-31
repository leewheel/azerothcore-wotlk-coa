-- 修正上游 rev_20261030_100_stormbringer_greater_calls_exclusivity.sql 的组成员违规：
-- 503319-503323 是 804018 的 rank 2-6、578312-578315 是 578311 的 rank 2-5，
-- SpellMgr 加载 spell_group 时要求成员必须是 first rank（GetRank()>1 报错并剔除，
-- SpellMgr.cpp:1966-1969），启动 Errors.log 出现 9 条 "is not first rank of spell"。
-- 叠层判定按 GetFirstRankSpell 解析（SpellMgr.cpp:814/819），只留 first rank 语义不变：
-- 804018 覆盖 503319-503323 整条链、578311 覆盖 578312-578315 整条链，
-- 578316（Greater Call of the Storm）与 680291（Greater Call of the Wind）不在 rank 链内、本身即 first rank。
-- By leewheel 20261031
DELETE FROM `spell_group` WHERE `id` = 1171 AND `spell_id` IN (503319, 503320, 503321, 503322, 503323, 578312, 578313, 578314, 578315);
