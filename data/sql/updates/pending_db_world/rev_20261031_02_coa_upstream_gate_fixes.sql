-- 门禁 Errors.log 清零：修复上游新内容引入的四类数据问题。
-- 1) 9916201/9916202（The Stormfang / Storm Conduit）：上游 rev_20261030_32 删除了其 smart_scripts，
--    但 AIName 仍为 SmartAI，触发 "SmartAI enabled but no SmartAI entries"。Stormfang 的行为已由
--    mod-skinpeelerquest 的 C++ 脚本接管（SkinpeelerQuest.cpp 注释明确"no CreatureAI of its own"），清空 AIName。
-- 2) 9916217（Tidal Bulwark）模型 466795 不存在于本客户端 CreatureDisplayInfo.dbc（patch-M 最新版
--    84502 行亦无），替换为现有水元素模型 5561，保留 DisplayScale 2。
-- 3) conditions 中 SourceType 1（creature loot template）SourceGroup 9916212/13/14 的行：上游
--    rev_20261030_32 已删除对应 creature_loot_template 行，条件悬空报 "does not exist"，删除。
-- 4) 262700..263813 共 15 个难度 1 条目：difficulty_entry_1 已填 ScriptName，与难度 0 重复，
--    核心规定难度 0 的 ScriptName 恒被采用并报警告，清空难度 1 条目的 ScriptName。
-- By leewheel 2026年10月29日
START TRANSACTION;

UPDATE `creature_template` SET `AIName` = '' WHERE `entry` IN (9916201, 9916202);

UPDATE `creature_template_model` SET `CreatureDisplayID` = 5561 WHERE `CreatureID` = 9916217 AND `CreatureDisplayID` = 466795;

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 1 AND `SourceGroup` IN (9916212, 9916213, 9916214);

UPDATE `creature_template` SET `ScriptName` = '' WHERE `entry` IN (262700, 262703, 262704, 262733, 262734, 262735, 262736, 262737, 262738, 262748, 262761, 262762, 262763, 262999, 263813);

-- 难度 2（36xxxx）条目同因同修
UPDATE `creature_template` SET `ScriptName` = '' WHERE `entry` IN (362700, 362703, 362704, 362733, 362734, 362735, 362736, 362737, 362738, 362748, 362761, 362762, 362763, 362999, 363813);

COMMIT;
