-- By leewheel 2026年10月26日 spell_proc 数据质量修复（Errors.log 治理，共约 400 条错误）
-- 依据核心 SpellMgr.cpp LoadSpellProcInfo 校验逻辑（2318-2357 行）逐类修复：
-- 1) ProcFlags 为空且 DBC 也无 ProcFlags 的死行（51 条错误/32 法术 + 71761 不存在）——proc 永远无法触发，删除
DELETE FROM `spell_proc` WHERE ABS(`SpellId`) IN (1120,6346,7001,8178,16180,16952,21890,23551,26107,26128,27243,31794,36032,37170,37336,37377,37379,37443,37519,37523,37603,38857,39437,44449,45234,45398,45483,51698,51700,51701,53386,64343,71761);

-- 2) HitMask 超出 PROC_HIT_MASK_ALL(0x2FFF)（209 条错误，值均为 32767）——按有效掩码截取，保留"全部命中类型"语义
UPDATE `spell_proc` SET `HitMask` = `HitMask` & 0x2FFF WHERE `HitMask` & ~0x2FFF;

-- 3) SpellTypeMask 已定义但 ProcFlags 不需要（34 条错误/13 行，排除已删死行）——清零
UPDATE `spell_proc` SET `SpellTypeMask` = 0 WHERE ABS(`SpellId`) IN (20165,20166,20375,300742,504304,561127,561340,680395,706220,707369,806070,806071,806229);

-- 4) SpellPhaseMask 已定义但 ProcFlags 不需要（74 条错误/39 行，排除已删死行）——清零
UPDATE `spell_proc` SET `SpellPhaseMask` = 0 WHERE ABS(`SpellId`) IN (12324,1556002,1571793,20165,20166,20375,288825,288927,30299,500286,500481,504304,504784,53590,53591,53592,536258,536259,536260,536261,536262,536263,557325,560487,561127,561340,680389,680395,705436,706220,706795,707369,804444,806070,806071,806229,806723,807547,92109);

-- 5) ProcFlags（DBC 提供）要求 SpellPhaseMask 但未定义（23 条错误/11 行）——补 PROC_SPELL_PHASE_HIT(2)
UPDATE `spell_proc` SET `SpellPhaseMask` = 2 WHERE ABS(`SpellId`) IN (324,12966,22648,46910,46911,51123,51127,51128,51129,51130,283066) AND `SpellPhaseMask` = 0;

-- 6) DisableEffectsMask 指向非光环效果（6 条错误/5 行）——清掉无效位（非光环效果本就不能通过光环触发 proc）
UPDATE `spell_proc` SET `DisableEffectsMask` = `DisableEffectsMask` & ~2 WHERE `SpellId` = 92109;
UPDATE `spell_proc` SET `DisableEffectsMask` = `DisableEffectsMask` & ~4 WHERE `SpellId` = 680692;
UPDATE `spell_proc` SET `DisableEffectsMask` = `DisableEffectsMask` & ~2 WHERE `SpellId` = 801076;
UPDATE `spell_proc` SET `DisableEffectsMask` = `DisableEffectsMask` & ~3 WHERE `SpellId` = 801096;
UPDATE `spell_proc` SET `DisableEffectsMask` = `DisableEffectsMask` & ~2 WHERE `SpellId` = 801242;

-- 7) PROC_ATTR_REQ_SPELLMOD 但法术无任何法术修正光环（3 条错误）——去掉该属性位，否则 proc 永不触发
UPDATE `spell_proc` SET `AttributesMask` = `AttributesMask` & ~8 WHERE `SpellId` IN (12536,16246,16870);
