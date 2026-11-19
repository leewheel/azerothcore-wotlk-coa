-- 2026.11.20 「还鲁尔自由」(6482)：鲁尔·雪蹄（12818）护送期间一直是阵营 714，对蓟皮伏击者（阵营 82）中立，
-- 于是 IsValidAttackTarget 判定不合法，他从不还手。改为接任务时切到部落护送者阵营 232
-- （FACTION_ESCORTEE_H_NEUTRAL_ACTIVE），重生时还原模板阵营。上游 #12818 议题 #8624。// By leewheel 20261120
DELETE FROM `smart_scripts` WHERE `entryorguid` = 12818 AND `source_type` = 0 AND `id` IN (20, 21);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`,
    `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`,
    `event_param6`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`,
    `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`,
    `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(12818, 0, 20, 0, 19, 0, 100, 512, 6482, 0, 0, 0, 0, 0, 2, 232, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
    'Ruul Snowhoof - On Quest \'Freedom to Ruul\' Taken - Set Faction 232'),
(12818, 0, 21, 0, 11, 0, 100, 512, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
    'Ruul Snowhoof - On Respawn - Restore Template Faction');
