-- 2026.11.19 剃刀沼泽：查尔加·刺鬃「闪电新星」改为半血只放一次（上游 #12812）
-- 事件改为「生命值 0-50%」，不重复触发。// By leewheel 20261119
UPDATE `smart_scripts` SET `event_type` = 2, `event_flags` = 1, `event_param1` = 0, `event_param2` = 50, `event_param3` = 0, `event_param4` = 0,
    `comment` = '查尔加·刺鬃 - 升腾装备组 - 生命值 0-50% - 施放「闪电新星」（不重复）'
WHERE `entryorguid` = 4421 AND `source_type` = 0 AND `id` = 9003 AND `action_type` = 11 AND `action_param1` = 2102774;
