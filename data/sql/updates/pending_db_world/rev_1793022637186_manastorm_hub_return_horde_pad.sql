-- 修复 Manastorm 数据store加载失败：部落侧回城传送台缺失
-- 症状：Server.log 报 "Manastorm datastore failed to load"，前一行显示
--   "Manastorm hub returns require exactly two valid rows ... Configured rows=2, valid resolved rows=1"
-- 根因：manastorm_hub_return 已配置 team_id=1 -> gameobject_guid 6901536，
--   但 gameobject 表中不存在 guid 6901536（联盟侧 6901535 存在，部落侧从未插入），
--   LoadHubReturns 的 INNER JOIN 只解析出 1 行，模块判失败。
-- 修复：按模块 base SQL 12_manastorm_hub_spawns.sql 中的期望坐标补插部落侧
--   Teleport Pad（entry 20832，map 1 奥格瑞玛，坐标 1648.1 / -4431.11 / 16.9532，
--   朝向 2.18527），GUID 冲突时跳过不覆盖。
-- By leewheel 2026年10月26日
INSERT INTO `gameobject`
(`guid`, `id`, `map`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `animprogress`, `state`)
SELECT
    6901536, 20832, 1, 1648.1, -4431.11, 16.9532, 2.18527, 300, 0, 1
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `gameobject` WHERE `guid` = 6901536);
-- End By leewheel
