-- 修正 Cenarion Hold Infantry（15184）On Aggro Say Line 0 的 talker 目标：
-- target_type=7(ACTION_INVOKER) 时 SMART_ACTION_TALK 取 invoker 生物做 talker
-- （SmartScript.cpp:243-253，useTalkTarget=0 则 talker=首个非宠物 creature 目标）。
-- 当 invoker 是 COA 召唤物 Apocalyptic Skies（533030，npc_ascension_cultist_summon）
-- 时，talker 变成 533030 而它没有 creature_text → 启动后 Errors.log 报
-- "using non-existent Text id 0 for talker 533030, ignored"（原版 invoker 是玩家时走
-- IsPlayer 分支 talker=me 不触发；仅生物 invoker 触发）。
-- 改 target_type=0(SELF)：喊话永远由 15184 自己说，与注释 "Say Line 0" 本意一致。
-- By leewheel 20261031
UPDATE `smart_scripts` SET `target_type` = 0 WHERE `entryorguid` = 15184 AND `source_type` = 0 AND `id` = 0 AND `action_type` = 1;
