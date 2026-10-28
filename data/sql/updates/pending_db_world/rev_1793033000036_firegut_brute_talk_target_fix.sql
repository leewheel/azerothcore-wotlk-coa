-- #By leewheel 2026年10月28日
-- 修复 Firegut Brute(7035) SAI：On Summon(event_type=4) 触发 TALK 时 target_type=7(召唤者)，
-- 而召唤者（如猎人召唤物 50224 Lesser Shadowhound）没有 creature_text，
-- 导致运行期报错 "SMART_ACTION_TALK: ... using non-existent Text id 0 for talker 50224, ignored"。
-- 修法：target 改为 self(1)，被召唤时由 7035 自己喊 group 0 文本（"Raaar!!! Me smash $r!" 等 3 条，数据齐全）。
UPDATE `smart_scripts`
SET `target_type` = 1, `comment` = 'Firegut Brute - On Summon - Say Line 0'
WHERE `entryorguid` = 7035 AND `source_type` = 0 AND `id` = 0 AND `event_type` = 4;
