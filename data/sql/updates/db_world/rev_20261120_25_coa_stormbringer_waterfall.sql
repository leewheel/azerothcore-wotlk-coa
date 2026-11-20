-- #12930 瀑布（806412）：「造成暴击伤害时，使你的所有冷却时间缩短 0.5 秒」。
-- 它的触发器 807661 只认三个法术，导致 spell_ascension_stormbringer_waterfall
-- 把 0.5 秒减到了身上所有正在冷却的风暴使者法术。原 proc 行只收魔法系直接伤害，
-- 本次补上近战、远程、无系别与周期性伤害，让任意暴击都能计入（ProcFlags 变为 332048）。
-- 本脚本无玩家可见文本。
-- By leewheel 20261120
-- End By leewheel
DELETE FROM `spell_script_names` WHERE `spell_id` = 807661 AND `ScriptName` = 'spell_ascension_stormbringer_waterfall';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES (807661, 'spell_ascension_stormbringer_waterfall');
UPDATE `spell_proc` SET `ProcFlags` = 332048 WHERE `SpellId` = 806412;
