-- 上游 #12110（c072b4e743）把 CreatureModelContainer 的键从 uint16 改成 uint32。
-- 改动前，高位 display id 会被截断成低 16 位去碰撞型表，撞上别的行就「碰巧有值」，
-- 所以这些行一直没缺；改成全 id 精确匹配后，缺行全部暴露，
-- 启动期 creature_template_model 加载对每一行缺行写一条 Errors.log（本次 509 条）。
--
-- 回填口径：按旧截断键（DisplayID & 0xFFFF）取回改动前服务端实际生效的那份数值，
-- 也就是玩家一直在用、没有任何异常反馈的那份，保证本次修复对玩家侧零手感变化。
-- 这样处理的有 499 行。
--
-- 其余 10 个 display id 的低 16 位等于自身，改动前本来就是缺行，
-- 在文件后段按模型数据单独补（前 9 个取 CollisionWidth/2 = 0.306 与默认接触距离 1.5，
-- 74032 取同模型 10623 的现成行）。
--
-- Alt 模型（DisplayID_Other_Gender）一律置 0：原截断行指向的是别的生物的女性模型，
-- 沿用会让随机性别的生物变成其它生物的样子，属于历史脏数据，这里一并了断。
-- By leewheel 20261112

INSERT INTO `creature_model_info`
    (`DisplayID`, `BoundingRadius`, `CombatReach`, `Gender`, `DisplayID_Other_Gender`, `VerifiedBuild`)
SELECT x.`did`, c.`BoundingRadius`, c.`CombatReach`, c.`Gender`, 0, 0
FROM (
    SELECT DISTINCT t.`CreatureDisplayID` AS `did`
    FROM `creature_template_model` t
    WHERE NOT EXISTS (SELECT 1 FROM `creature_model_info` m WHERE m.`DisplayID` = t.`CreatureDisplayID`)
) x
JOIN `creature_model_info` c ON c.`DisplayID` = (x.`did` & 0xFFFF);

-- 以下 10 行是截断键等于自身的 display id，改动前就没有模型数据，单独补。
INSERT IGNORE INTO `creature_model_info`
    (`DisplayID`, `BoundingRadius`, `CombatReach`, `Gender`, `DisplayID_Other_Gender`, `VerifiedBuild`) VALUES
(12090,  0.306,   1.5,     0, 0, 0),
(21730,  1,       1.5,     0, 0, 0),
(22477,  0.306,   1.5,     0, 0, 0),
(22478,  0.306,   1.5,     0, 0, 0),
(32108,  0.306,   1.5,     0, 0, 0),
(37369,  0.306,   1.5,     0, 0, 0),
(42352,  0.306,   1.5,     0, 0, 0),
(74032,  0.79443, 2.64066, 0, 0, 0),
(137328, 0.306,   1.5,     0, 0, 0),
(405062, 0.306,   1.5,     0, 0, 0);
-- By leewheel 20261112
