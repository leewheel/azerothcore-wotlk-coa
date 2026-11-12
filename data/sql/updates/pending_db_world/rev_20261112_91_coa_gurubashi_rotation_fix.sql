-- 荆棘谷竞技场宝箱（GUID 12101019）旋转四元数不是单位四元数，核心按 1e-5 容差校验后
-- 退化成「只绕 Z 轴按 orientation 朝向」，并写一条 Errors.log。
-- 原值 (0, 0, 0.98324, 0.18221) 平方和 = 0.9999614，偏差 3.86e-5 超出容差。
-- 这里把 rotation3 按 sqrt(1 - rotation2^2) 补正，平方和回到 1（偏差 < 1e-6），朝向与 orientation 2.77507 一致。
-- By leewheel 20261112

UPDATE `gameobject`
SET `rotation2` = 0.983250, `rotation3` = 0.1822630
WHERE `guid` = 12101019 AND `id` = 179697;

-- End By leewheel
