-- 巫毒之神的代言（Voice of Bwonsamdi，801716）只在周期性伤害上触发爆炸，而它的事件处理
-- 把每个暗影傀儡（802745）的命中都当成周期性伤害。这些命中其实是魔法系直接伤害，
-- 原行的 ProcFlags 只收周期性伤害，处理函数根本收不到它们。
-- 本次补上 PROC_FLAG_DONE_SPELL_MAGIC_DMG_CLASS_NEG（0x10000），ProcFlags 变为 327680。
-- 上游 #12787。本脚本无玩家可见文本。
-- By leewheel 20261120
-- End By leewheel
UPDATE `spell_proc` SET `ProcFlags` = 327680 WHERE `SpellId` = 801716;
