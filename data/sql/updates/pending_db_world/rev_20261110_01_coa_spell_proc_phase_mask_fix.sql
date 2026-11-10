-- By leewheel 20261110
-- 修上游 rev_20261108_741_mokrash_circlet_proc.sql 带进来的 4 条 spell_proc 校验错误。
-- 现象：worldserver 启动时 Errors.log 报
--   `spell_proc` table entry for SpellId 304007/312980/316980/320980 has `SpellPhaseMask` value defined,
--   but it won't be used for defined `ProcFlags` value
-- 原因：这 4 行是「被近战击中时触发」（受击类），ProcFlags = 40 =
--   PROC_FLAG_TAKEN_MELEE_AUTO_ATTACK(0x8) | PROC_FLAG_TAKEN_SPELL_MELEE_DMG_CLASS(0x20)。
--   核心 SpellMgr.cpp 的校验要求：只有带 REQ_SPELL_PHASE_PROC_FLAG_MASK（施法完成类）的 ProcFlags
--   才允许填 SpellPhaseMask；受击类根本不读这个字段，填了就是死数据，加载器直接记为错误。
-- 处理：把这 4 行的 SpellPhaseMask 归零。受击类触发走 HitMask，行为一点不变。
-- 注：上游源文件不改（它已有 updates 记录，改文件会让 hash 对不上），用这条后续脚本收口。
-- End By leewheel

UPDATE `spell_proc` SET `SpellPhaseMask` = 0 WHERE `SpellId` IN (304007, 312980, 316980, 320980);
