-- 补阿塔祖尔（Atal'zul）灵魂容器的模型基础数据。
-- 上游 rev_20261107_14_coa_atalzul_world_boss.sql 给 67536（Soul Vessel）和 67537（Soul Vessel Barrier）
-- 写了 creature_template_model，却没写 creature_model_info，服务端加载生物模板时报
--   No model data exist for `CreatureDisplayID` = 47751 listed by creature (Entry: 67536).
--   No model data exist for `CreatureDisplayID` = 461865 listed by creature (Entry: 67537).
-- 这两条是 LOG_ERROR，会写进 Errors.log，卡门禁。这里按客户端 DBC 的尺寸补上。
-- By leewheel 20261113

-- 47751：漂浮的紫色水晶。CreatureDisplayInfo 47751 → CreatureModelData 5128，
-- 其中 CollisionWidth = 2.901，取半径 1.4505；CombatReach 取常规 1.5。
-- 461865：奥术炸弹的导弹球。客户端 DBC 里这个模型 CollisionWidth 是 0，
-- 但上游 SQL 的注释写明原模型球径 8.3 码、DisplayScale = 3.6，即 30 码直径，所以半径取 14.94。
-- 两行 Gender 都是 2（无性别），因为没有异形模型。
-- 若以后想让护罩不挡人，把 461865 的 BoundingRadius 改回 4.15（原始球径的一半）即可。

DELETE FROM `creature_model_info` WHERE `DisplayID` IN (47751, 461865);
INSERT INTO `creature_model_info`
  (`DisplayID`, `BoundingRadius`, `CombatReach`, `Gender`, `DisplayID_Other_Gender`, `VerifiedBuild`)
VALUES
  (47751, 1.4505, 1.5, 2, 0, 12340),
  (461865, 14.94, 15, 2, 0, 12340);
