-- By leewheel 2026年11月11日
-- 上游改为 SpellRank.dbc 驱动技能阶数后，门禁 Errors.log 暴露的三类库表脏数据，一并修掉
-- 现象（39 行，全部来自 3395 启动）：
--   a) Spell X listed in `spell_group` is not first rank of spell  —— 25 条
--   b) req_spell X and spell_id Y in `spell_required` are ranks of the same spell —— 12 条
--   c) Spell -7302 listed in `spell_proc` is not first rank of spell —— 1 条

-- ============ a) spell_group 非首阶 ============
-- 依据客户端 SpellRank.dbc 修正 spell_group 里「非首阶」条目（核心启动会报 not first rank of spell）
-- 规则：同组已有该链首阶 → 删除非首阶；没有 → 替换为首阶（避免该链整体失去分组）

-- 1) 删除冗余的非首阶条目（同组首阶已存在）
DELETE FROM `spell_group` WHERE `id` = 1002 AND `spell_id` = 25782; -- 首阶 19740 已在组内
DELETE FROM `spell_group` WHERE `id` = 1005 AND `spell_id` = 25894; -- 首阶 19742 已在组内
DELETE FROM `spell_group` WHERE `id` = 1006 AND `spell_id` = 25898; -- 首阶 20217 已在组内
DELETE FROM `spell_group` WHERE `id` = 1007 AND `spell_id` = 25899; -- 首阶 20911 已在组内
DELETE FROM `spell_group` WHERE `id` = 1098 AND `spell_id` = 27683; -- 首阶 976 已在组内
DELETE FROM `spell_group` WHERE `id` = 1133 AND `spell_id` = 567237; -- 首阶 705070 已在组内
DELETE FROM `spell_group` WHERE `id` = 1210 AND `spell_id` = 300887; -- 首阶 300857 已在组内
DELETE FROM `spell_group` WHERE `id` = 103955 AND `spell_id` = 572816; -- 首阶 572810 已在组内
DELETE FROM `spell_group` WHERE `id` = 2100004 AND `spell_id` = 707340; -- 首阶 706630 已在组内
DELETE FROM `spell_group` WHERE `id` = 2110001 AND `spell_id` = 300887; -- 首阶 300857 已在组内
DELETE FROM `spell_group` WHERE `id` = 2110001 AND `spell_id` = 501330; -- 首阶 800212 已在组内
DELETE FROM `spell_group` WHERE `id` = 2110001 AND `spell_id` = 501331; -- 首阶 800212 已在组内
DELETE FROM `spell_group` WHERE `id` = 2110001 AND `spell_id` = 501332; -- 首阶 800212 已在组内
DELETE FROM `spell_group` WHERE `id` = 2110001 AND `spell_id` = 501333; -- 首阶 800212 已在组内
DELETE FROM `spell_group` WHERE `id` = 2110001 AND `spell_id` = 707678; -- 首阶 706741 已在组内
DELETE FROM `spell_group` WHERE `id` = 2110002 AND `spell_id` = 707340; -- 首阶 706630 已在组内
DELETE FROM `spell_group` WHERE `id` = 2110003 AND `spell_id` = 707677; -- 首阶 707671 已在组内
DELETE FROM `spell_group` WHERE `id` = 2110004 AND `spell_id` = 523484; -- 首阶 523478 已在组内
DELETE FROM `spell_group` WHERE `id` = 2110004 AND `spell_id` = 523494; -- 首阶 523489 已在组内
DELETE FROM `spell_group` WHERE `id` = 2110004 AND `spell_id` = 803656; -- 首阶 803651 已在组内
DELETE FROM `spell_group` WHERE `id` = 2110005 AND `spell_id` = 561143; -- 首阶 560294 已在组内

-- 2) 把非首阶替换为该链首阶
UPDATE `spell_group` SET `spell_id` = 1243 WHERE `id` = 1075 AND `spell_id` = 21562;
UPDATE `spell_group` SET `spell_id` = 14752 WHERE `id` = 1077 AND `spell_id` = 27681;
UPDATE `spell_group` SET `spell_id` = 1126 WHERE `id` = 1079 AND `spell_id` = 21849;
UPDATE `spell_group` SET `spell_id` = 1459 WHERE `id` = 1080 AND `spell_id` = 23028;

-- ============ b) spell_required 同链冗余（req 与本身是同一法术的不同阶，条目无意义）============
DELETE FROM `spell_required` WHERE `spell_id` = 25782 AND `req_spell` = 19838;
DELETE FROM `spell_required` WHERE `spell_id` = 25894 AND `req_spell` = 19854;
DELETE FROM `spell_required` WHERE `spell_id` = 25899 AND `req_spell` = 20911;
DELETE FROM `spell_required` WHERE `spell_id` = 25916 AND `req_spell` = 25291;
DELETE FROM `spell_required` WHERE `spell_id` = 25918 AND `req_spell` = 25290;
DELETE FROM `spell_required` WHERE `spell_id` = 27141 AND `req_spell` = 27140;
DELETE FROM `spell_required` WHERE `spell_id` = 27143 AND `req_spell` = 27142;
DELETE FROM `spell_required` WHERE `spell_id` = 27681 AND `req_spell` = 14752;
DELETE FROM `spell_required` WHERE `spell_id` = 48933 AND `req_spell` = 48931;
DELETE FROM `spell_required` WHERE `spell_id` = 48934 AND `req_spell` = 48932;
DELETE FROM `spell_required` WHERE `spell_id` = 48937 AND `req_spell` = 48935;
DELETE FROM `spell_required` WHERE `spell_id` = 48938 AND `req_spell` = 48936;

-- ============ c) spell_proc 负号 ID 不是链首阶 ============
-- -7302 表示「7302 所在链」，但 7302 是 168 链的第 4 阶；
-- 库里已存在 -168（配置与 -7302 逐字段完全相同：ProcFlags 0 / SpellTypeMask 1 / HitMask 1027 / AttributesMask 2），
-- 属于同一条链的重复条目，直接删掉 -7302，避免改成 -168 时主键冲突。
DELETE FROM `spell_proc` WHERE `SpellId` = -7302;

-- End By leewheel
