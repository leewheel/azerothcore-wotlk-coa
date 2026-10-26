-- By leewheel 2026年10月26日
-- 修复两类 creature 运动校验错误：
-- 1) creature_formations："member ... cannot have follow distance or follow angle
--    because don't have GROUP_AI_FLAG_FOLLOW_LEADER flag"——6 个成员行 groupAI=2
--    无 FOLLOW_LEADER 位，dist/angle 运行时被强制置 0，DB 同步置 0（等效）。
-- 2) creature："has movement type set to WAYPOINT_MOTION_TYPE but no path assigned"——
--    4 个 spawn（entry 11260）无路径，MovementType 置 0。
-- 备份：Tempfiles/db_backup_20261026/backup_round2c_20261026.txt

UPDATE creature_formations SET dist = 0, angle = 0 WHERE memberGUID IN (79651, 79894, 80270, 79900, 80341, 80343);

UPDATE creature SET MovementType = 0 WHERE guid IN (80119, 80127, 80145, 80262);
