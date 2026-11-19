-- 2026.11.19 智慧球任务链：金币奖励在 60 级封顶（上游 #12748）
-- 9417101~9417117 视为 60 级任务，9417116/9417117 按难度 6（60 级）计算，避免满级后金币超发。// By leewheel 20261119
UPDATE `quest_template` SET `Flags` = `Flags` | 0x100 WHERE `ID` BETWEEN 9417101 AND 9417117;
UPDATE `quest_template` SET `RewardMoneyDifficulty` = 6 WHERE `ID` IN (9417116, 9417117);
