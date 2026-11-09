-- By leewheel 2026年11月9日
-- 本轮上游更新（2026-11-09 拉取 5+2 个提交）玩家可见文本汉化，逐条 SQL 全量核对后的补漏：
--   1) rev_20261108_95_coa_pale_reach_fey_dust_reward_text.sql：任务 175025「精灵尘」交任务文本
--   2) rev_20261108_9921_coa_pale_reach_boring_peace_texts.sql：任务 175343「无聊的和平」进度文本 + 交任务文本
--   3) rev_20261106_33_sunken_temple_hakkar_summons_difficulty.sql：沉没的神庙 4 个困难模板（108437/108438/208437/208438）
--   4) rev_20261108_95_coa_worldforged_editor_batch_5.sql：4 个新建物件模板（Night Elf Cart / Nail / Raider's Sailboat / Sand Pile）
--   5) 历史译名统一：「灰空」→「灰天」（Graysky），全局口径以 34 条任务 + 19 条奖励文本的既有译法为准
-- 一律 INSERT ... ON DUPLICATE KEY UPDATE，可安全重复执行。
-- 执行顺序要求：本文件按文件名排在上述基础 SQL 之后，基础行必然已存在。
-- End By leewheel

-- 1) 「精灵尘」交任务文本（贝尔德雷德）
INSERT INTO `quest_offer_reward_locale` (`ID`, `locale`, `RewardText`, `VerifiedBuild`) VALUES
(175025, 'zhCN', '<贝尔德雷德把她那鹰钩鼻凑近精灵尘，深深吸了一口四溢的魔力。有那么一瞬，她翻起了白眼。>$B$B啊！好。我很满意，是的。这些够我用上好几个月了。$B$B谁也别想说贝尔德雷德言而无信！你还在那些娇小尸体上抖落尘粉的时候，我就已经动手熬制药水了。$B$B只差一会儿就能熬好。', 12340)
ON DUPLICATE KEY UPDATE `RewardText` = VALUES(`RewardText`), `VerifiedBuild` = VALUES(`VerifiedBuild`);

-- 2) 「无聊的和平」进度文本（阿尔卡里安）
INSERT INTO `quest_request_items_locale` (`ID`, `locale`, `CompletionText`, `VerifiedBuild`) VALUES
(175343, 'zhCN', '嗯？有什么事吗？', 12340)
ON DUPLICATE KEY UPDATE `CompletionText` = VALUES(`CompletionText`), `VerifiedBuild` = VALUES(`VerifiedBuild`);

-- 3) 「无聊的和平」交任务文本（阿尔卡里安）
INSERT INTO `quest_offer_reward_locale` (`ID`, `locale`, `RewardText`, `VerifiedBuild`) VALUES
(175343, 'zhCN', '啊，我兄弟瓦埃洛尔寄来的信。$B$B他究竟有没有一天不再坚持？我看悬。他现在跟小时候一样固执。$B$B你看，他想让我搬到纳马里恩去。那座圣所。让我学他，也学许许多多其他高等精灵的样。$B$B可说实话……我在灰天待得挺自在。那份安宁，我想，只会叫我发闷。$B$B我会回封信，就这么跟他说。', 12340)
ON DUPLICATE KEY UPDATE `RewardText` = VALUES(`RewardText`), `VerifiedBuild` = VALUES(`VerifiedBuild`);

-- 4) 沉没的神庙：哈卡莱爪牙 / 哈卡莱护血者的英雄与神话模板（名字沿用本体译名，与 108336 等既有困难模板一致）
INSERT INTO `creature_template_locale` (`entry`, `locale`, `Name`, `Title`, `VerifiedBuild`) VALUES
(108437, 'zhCN', '哈卡莱爪牙',   NULL, 12340),
(208437, 'zhCN', '哈卡莱爪牙',   NULL, 12340),
(108438, 'zhCN', '哈卡莱护血者', NULL, 12340),
(208438, 'zhCN', '哈卡莱护血者', NULL, 12340)
ON DUPLICATE KEY UPDATE `Name` = VALUES(`Name`), `Title` = VALUES(`Title`), `VerifiedBuild` = VALUES(`VerifiedBuild`);

-- 5) 世界编辑器第 5 批新建的 4 个物件（鼠标悬停可见名字）
INSERT INTO `gameobject_template_locale` (`entry`, `locale`, `name`, `castBarCaption`, `VerifiedBuild`) VALUES
(3297126, 'zhCN', '暗夜精灵手推车', '', 12340),
(9900050, 'zhCN', '钉子',           '', 12340),
(515938,  'zhCN', '掠夺者帆船',     '', 12340),
(9900049, 'zhCN', '沙堆',           '', 12340)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `castBarCaption` = VALUES(`castBarCaption`), `VerifiedBuild` = VALUES(`VerifiedBuild`);

-- 6) 历史译名统一：Graysky 在库内已有 34 条任务 + 19 条奖励文本译作「灰天」，
--    早期 4 处误作「灰空」，此处统一为「灰天」，避免同一地名两种写法。
UPDATE `quest_template_locale`
SET `Details` = REPLACE(`Details`, '灰空', '灰天'),
    `Objectives` = REPLACE(`Objectives`, '灰空', '灰天'),
    `EndText` = REPLACE(`EndText`, '灰空', '灰天'),
    `CompletedText` = REPLACE(`CompletedText`, '灰空', '灰天')
WHERE `locale` = 'zhCN' AND `ID` IN (175007, 175010, 175054);

UPDATE `quest_offer_reward_locale`
SET `RewardText` = REPLACE(`RewardText`, '灰空', '灰天')
WHERE `locale` = 'zhCN' AND `RewardText` LIKE '%灰空%';
