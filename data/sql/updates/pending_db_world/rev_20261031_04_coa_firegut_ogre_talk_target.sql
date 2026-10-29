-- 修复 Firegut Ogre (7033) On Aggro 喊话目标导致的 Errors.log 报错
-- 原数据 useTalkTarget=0：invoker 为非宠物生物（如 necromancer 模块召唤物 Skeletal Smith 50261）时
-- talker 被选为该生物，其无 creature_text -> "SMART_ACTION_TALK ... non-existent Text id 0" ERROR；
-- invoker 为玩家时靠 IsPlayer 分支兜底才未暴露（base 官方数据即 param3=0，属上游数据缺陷）。
-- action_param3=1 后 talker 恒为 7033 自己（有 group 0 文本），invoker 作为听者，
-- 与注释 "Firegut Ogre - On Aggro - Say Line 0" 的本意一致。
-- #By leewheel 2026年10月29日
UPDATE `smart_scripts`
SET `action_param3` = 1
WHERE `entryorguid` = 7033 AND `source_type` = 0 AND `id` = 0 AND `action_type` = 1 AND `target_type` = 7;
