-- 智慧球 Q10：卡德加护送改用跑步（speed_run 0.9），护送启动动作改为「跑步 + 防御」，
-- 目标指向自身，避免按距离判定提前结束；真正的中止交给 C++ 的 wisdomball_escort_wait
-- 在 25 码内没有玩家时处理。上游 #12790。本脚本无玩家可见文本。
-- By leewheel 20261120
-- End By leewheel

UPDATE `creature_template` SET `speed_run` = 0.9 WHERE `entry` = 9417004;
UPDATE `smart_scripts` SET `action_param1` = 2, `comment` = 'Khadgar (Escort) - Linked - Start escort (run, defensive; target self: no player stored, so it never ends on distance - C++ wisdomball_escort_wait stops him when no player is within 25 yd)' WHERE `entryorguid` = 9417004 AND `source_type` = 0 AND `id` = 2;
