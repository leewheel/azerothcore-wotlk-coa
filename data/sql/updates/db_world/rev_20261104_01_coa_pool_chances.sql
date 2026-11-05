-- Wintergrasp 草药刷新池 Node 9（pool 23250）三个成员的显式概率合计只有 82，核心判定为损坏池
-- （Pool Id 23250 has no equal chance pooled entities defined and explicit chance sum is not 100）。
-- 按原有比例 17/60/5 折算到 100：21/73/6。
-- By leewheel 2026年11月04日
UPDATE `pool_gameobject` SET `chance` = 21 WHERE `pool_entry` = 23250 AND `guid` = 574542;
UPDATE `pool_gameobject` SET `chance` = 73 WHERE `pool_entry` = 23250 AND `guid` = 574544;
UPDATE `pool_gameobject` SET `chance` = 6  WHERE `pool_entry` = 23250 AND `guid` = 574545;
-- End By leewheel
