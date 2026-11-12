-- 2026.11.12 上游同步（9 提交）玩家可见文本汉化
-- 覆盖：Pale Reach「给女巫的苔藓」「欢迎的代价」两个任务的进度/交付窗口、
--       拉尔达招呼语、安达斯特新兵挑战选项、悬挂霉菌与巢穴两个物件名
-- 只写 zhCN，原表英文不动
-- By leewheel 20261112

-- 175336 给女巫的苔藓：进度窗口
INSERT INTO `quest_request_items_locale` (`ID`, `locale`, `CompletionText`, `VerifiedBuild`) VALUES
(175336, 'zhCN', '我的苔藓呢？', 0)
ON DUPLICATE KEY UPDATE `CompletionText` = VALUES(`CompletionText`);

-- 175336 给女巫的苔藓：交付窗口
INSERT INTO `quest_offer_reward_locale` (`ID`, `locale`, `RewardText`, `VerifiedBuild`) VALUES
(175336, 'zhCN', '很好。这些够用了。$B$B<迪尔德丽打了个响指，苔藓便从你手中魔法般地消失。>$B$B你知道的，这是增强剂，用在我们的仪式里。它能把心智托举到肉体的重负与累赘之上，一直送到灵魂世界的穹顶。', 0)
ON DUPLICATE KEY UPDATE `RewardText` = VALUES(`RewardText`);

-- 175335 欢迎的代价：进度窗口
INSERT INTO `quest_request_items_locale` (`ID`, `locale`, `CompletionText`, `VerifiedBuild`) VALUES
(175335, 'zhCN', '狩猎还顺利吗？', 0)
ON DUPLICATE KEY UPDATE `CompletionText` = VALUES(`CompletionText`);

-- 175335 欢迎的代价：交付窗口
INSERT INTO `quest_offer_reward_locale` (`ID`, `locale`, `RewardText`, `VerifiedBuild`) VALUES
(175335, 'zhCN', '啊！$B$B<明德拉翻了个白眼，嗅了嗅那块肉。>$B$B就算是生的，我也吃得下。$B$B很好，这才叫我满意！你为自己挣来了一份小小的、怯生生的、还带条件的欢迎。', 0)
ON DUPLICATE KEY UPDATE `RewardText` = VALUES(`RewardText`);

-- 拉尔达（164236）招呼语：上游修掉了开头残留的西班牙语问号，这里补中文
INSERT INTO `creature_text_locale` (`CreatureID`, `GroupID`, `ID`, `Locale`, `Text`) VALUES
(164236, 0, 0, 'zhCN', '多萝西……？哦……')
ON DUPLICATE KEY UPDATE `Text` = VALUES(`Text`);

-- 安达斯特新兵挑战选项（gossip 100705）：补回蓝色任务标记，文本译成中文
INSERT INTO `gossip_menu_option_locale` (`MenuID`, `OptionID`, `Locale`, `OptionText`) VALUES
(100705, 0, 'zhCN', '|cFF0000FF(任务)|r我是来协助你训练的。准备战斗！')
ON DUPLICATE KEY UPDATE `OptionText` = VALUES(`OptionText`);

-- 物件名：悬挂霉菌 / 巢穴
INSERT INTO `gameobject_template_locale` (`entry`, `locale`, `name`, `castBarCaption`, `VerifiedBuild`) VALUES
(2399012, 'zhCN', '悬挂的霉菌', '', 0),
(2399013, 'zhCN', '巢穴', '', 0)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- End By leewheel
