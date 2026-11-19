-- 2026.11.19 剃刀沼泽：唤地者哈姆加（生物 4842）刷新点校正（上游 #12811 / 议题 #12655）
-- 移到实测服玩家熟悉的位置，比 AzerothCore 原始坐标向西约 65 码。// By leewheel 20261119
UPDATE `creature` SET `position_x` = 2058.24, `position_y` = 1734.22, `position_z` = 76.607, `orientation` = 0.43
WHERE `guid` = 1975863 AND `id` = 4842;
