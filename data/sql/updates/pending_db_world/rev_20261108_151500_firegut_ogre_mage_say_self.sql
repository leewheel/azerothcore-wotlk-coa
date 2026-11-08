-- By leewheel 2026年11月8日
-- Firegut Ogre Mage（entry 7034）的「On Aggro - Say Line 0」把目标设成了「触发者」（target_type = 7）。
-- 触发者可能是任何攻击它的生物，例如 51275 Rotting Frost Giant —— 那只怪没有 creature_text，
-- 于是每次触发都打一条运行时警告：
--   SmartScript::ProcessAction: SMART_ACTION_TALK: EntryOrGuid 7034 ... using non-existent Text id 0
-- 改成「自己说话」（target_type = 1）：7034 的 creature_text GroupID 0 本来就有三句台词，
-- 这才是这条动作原本想做的事。
-- 只改这一条，其余 SmartAI 不动；重复执行安全（条件已限定 entryorguid/id/action_type）。

UPDATE `smart_scripts`
SET `target_type` = 1
WHERE `entryorguid` = 7034
  AND `id` = 0
  AND `action_type` = 1
  AND `target_type` = 7;
-- End By leewheel
