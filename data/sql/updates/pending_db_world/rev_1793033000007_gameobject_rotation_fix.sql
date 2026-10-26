-- By leewheel 2026年10月26日 gameobject 四元数规范化修复（Errors.log 7 条，含此前 6901536 同类）
-- 原值为 4 位小数近似（模长偏差>=1e-5 触发 ObjectMgr.cpp:3126-3130 报错）。
-- 按核心 fallback 相同语义：由 orientation 重算 Z 轴四元数（x=0,y=0,z=sin(o/2),w=cos(o/2)）写入精确值。
UPDATE `gameobject` SET `rotation0`=0, `rotation1`=0, `rotation2`=SIN(`orientation`/2), `rotation3`=COS(`orientation`/2) WHERE `guid` IN (30018,6901536,6940869,9001374,9370001,9980016,9980030);
