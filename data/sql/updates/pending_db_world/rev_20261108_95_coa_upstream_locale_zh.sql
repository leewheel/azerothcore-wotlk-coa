-- By leewheel 2026年11月8日
-- 本轮上游更新（2026-11-08 拉取）玩家可见文本汉化，逐条 SQL 全量核对后的补漏：
--   1) rev_20261108_01_high_risk_refineries.sql：18 个物件名 + 14 个生物名/头衔
--   2) rev_20261107_01_highrisk_hidden_caches.sql：24 个物件名（隐藏宝箱三档）
--   3) rev_20261108_90/91/92_coa_pale_reach_*.sql：4 条任务进度文本 + 1 条交任务文本
-- 一律 INSERT ... ON DUPLICATE KEY UPDATE，可安全重复执行。
-- 执行顺序要求：本文件按文件名排在上述基础 SQL 之后，基础行必然已存在。
-- End By leewheel

-- 1) 高风险精炼设施：18 个物件名
INSERT INTO `gameobject_template_locale` (`entry`, `locale`, `name`, `castBarCaption`, `VerifiedBuild`) VALUES
(395676, 'zhCN', '受祝福的锻造炉',       '', 12340),
(395715, 'zhCN', '白骨祭坛',             '', 12340),
(395721, 'zhCN', '受祝福的剥皮桌',       '', 12340),
(395749, 'zhCN', '源质营火',             '', 12340),
(395754, 'zhCN', '地狱祭坛',             '', 12340),
(395763, 'zhCN', '出土的远古祭坛',       '', 12340),
(395780, 'zhCN', '暗影烈焰营火',         '', 12340),
(395787, 'zhCN', '幽魂织机',             '', 12340),
(395797, 'zhCN', '月织织机',             '', 12340),
(395802, 'zhCN', '环保超级制革机',       '', 12340),
(395804, 'zhCN', '熔岩花',               '', 12340),
(395805, 'zhCN', '恐惧谷余烬花',         '', 12340),
(395828, 'zhCN', '索瑞森战争熔炉',       '', 12340),
(395831, 'zhCN', '寒冰熔炉',             '', 12340),
(395843, 'zhCN', '贪婪鞭笞荆棘',         '', 12340),
(395912, 'zhCN', '海神祭坛',             '', 12340),
(395932, 'zhCN', '奥术火坑',             '', 12340),
(395934, 'zhCN', '火酒锅',               '', 12340)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `castBarCaption` = VALUES(`castBarCaption`), `VerifiedBuild` = VALUES(`VerifiedBuild`);

-- 2) 高风险精英：14 个生物名与头衔
INSERT INTO `creature_template_locale` (`entry`, `locale`, `Name`, `Title`, `VerifiedBuild`) VALUES
(911882, 'zhCN', '地狱之触术士',     NULL,       12340),
(918547, 'zhCN', '瘟疫培育者',       '诅咒教派', 12340),
(918550, 'zhCN', '黑暗女巫',         '诅咒教派', 12340),
(918555, 'zhCN', '邪恶屠夫',         '诅咒教派', 12340),
(918562, 'zhCN', '暮光掘地者',       NULL,       12340),
(918578, 'zhCN', '阿科兰的选民',     NULL,       12340),
(918588, 'zhCN', '上层精灵裁缝',     NULL,       12340),
(918589, 'zhCN', '悲恸小精灵',       NULL,       12340),
(918590, 'zhCN', '悲伤的灵魂',       NULL,       12340),
(918591, 'zhCN', '悲伤的灵魂',       NULL,       12340),
(918647, 'zhCN', '地精制革师',       NULL,       12340),
(919448, 'zhCN', '血色大师剥皮师',   NULL,       12340),
(919450, 'zhCN', '血色大师铁匠',     NULL,       12340),
(997440, 'zhCN', '冬泉酿酒师',       NULL,       12340)
ON DUPLICATE KEY UPDATE `Name` = VALUES(`Name`), `Title` = VALUES(`Title`), `VerifiedBuild` = VALUES(`VerifiedBuild`);

-- 3) 隐藏宝箱：24 个物件名（三档：普通 / 稀有 / 史诗）
INSERT INTO `gameobject_template_locale` (`entry`, `locale`, `name`, `castBarCaption`, `VerifiedBuild`) VALUES
(967048, 'zhCN', '隐藏宝箱', '', 12340),
(967049, 'zhCN', '稀有隐藏宝箱', '', 12340),
(967050, 'zhCN', '史诗隐藏宝箱', '', 12340),
(967033, 'zhCN', '隐藏宝箱', '', 12340),
(967034, 'zhCN', '稀有隐藏宝箱', '', 12340),
(967035, 'zhCN', '史诗隐藏宝箱', '', 12340),
(967039, 'zhCN', '隐藏宝箱', '', 12340),
(967040, 'zhCN', '稀有隐藏宝箱', '', 12340),
(967041, 'zhCN', '史诗隐藏宝箱', '', 12340),
(967042, 'zhCN', '隐藏宝箱', '', 12340),
(967043, 'zhCN', '稀有隐藏宝箱', '', 12340),
(967044, 'zhCN', '史诗隐藏宝箱', '', 12340),
(967017, 'zhCN', '隐藏宝箱', '', 12340),
(967030, 'zhCN', '稀有隐藏宝箱', '', 12340),
(967031, 'zhCN', '史诗隐藏宝箱', '', 12340),
(967045, 'zhCN', '隐藏宝箱', '', 12340),
(967046, 'zhCN', '稀有隐藏宝箱', '', 12340),
(967047, 'zhCN', '史诗隐藏宝箱', '', 12340),
(967051, 'zhCN', '隐藏宝箱', '', 12340),
(967052, 'zhCN', '稀有隐藏宝箱', '', 12340),
(967053, 'zhCN', '史诗隐藏宝箱', '', 12340),
(967036, 'zhCN', '隐藏宝箱', '', 12340),
(967037, 'zhCN', '稀有隐藏宝箱', '', 12340),
(967038, 'zhCN', '史诗隐藏宝箱', '', 12340)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `castBarCaption` = VALUES(`castBarCaption`), `VerifiedBuild` = VALUES(`VerifiedBuild`);

-- 4) 苍白海岸任务进度文本（交任务窗口）
INSERT INTO `quest_request_items_locale` (`ID`, `locale`, `CompletionText`, `VerifiedBuild`) VALUES
(175034, 'zhCN', '毛皮到手了吗？', 12340),
(175323, 'zhCN', '心脏带来了吗？斯卡迪尔德那地方，除了该死的乌鸦，最不缺的就是狐狸。', 12340),
(175324, 'zhCN', '外面情况如何？东西都齐了吗？', 12340),
(175327, 'zhCN', '你找到她了吗？', 12340)
ON DUPLICATE KEY UPDATE `CompletionText` = VALUES(`CompletionText`), `VerifiedBuild` = VALUES(`VerifiedBuild`);

-- 5) 「悬赏一颗头颅」交任务文本
INSERT INTO `quest_offer_reward_locale` (`ID`, `locale`, `RewardText`, `VerifiedBuild`) VALUES
(175038, 'zhCN', '你杀了他。该死，你真的杀了他。我甚至不确定单打独斗我能不能赢他。$B$B但约定就是约定，我们说好把赏金平分的。$B$B拿着吧。你已经挣得了提前领取自己那一份的权利。看我这副样子，光赶到灰天恐怕就得几天。', 12340)
ON DUPLICATE KEY UPDATE `RewardText` = VALUES(`RewardText`), `VerifiedBuild` = VALUES(`VerifiedBuild`);

-- 6) 物品套装备注名本地化兜底
-- rev_20261029_04_item_set_fallback_names.sql 会从 item_template 补进约 1 万条英文备注名，
-- 而套装备注名是玩家可见的（CMSG_ITEM_NAME_QUERY → SMSG_ITEM_NAME_QUERY_RESPONSE），
-- 因此这里统一用 item_template_locale 的中文物品名补齐 zhCN 行。
-- 通用写法，不依赖具体 ID 列表：任何缺 zhCN 行且物品有中文名的备注名都会补上，可重复执行。
INSERT INTO `item_set_names_locale` (`ID`, `locale`, `Name`, `VerifiedBuild`)
SELECT `n`.`entry`, 'zhCN', `t`.`Name`, 12340
FROM `item_set_names` AS `n`
JOIN `item_template_locale` AS `t` ON `t`.`ID` = `n`.`entry` AND `t`.`locale` = 'zhCN'
LEFT JOIN `item_set_names_locale` AS `l` ON `l`.`ID` = `n`.`entry` AND `l`.`locale` = 'zhCN'
WHERE `l`.`ID` IS NULL AND `t`.`Name` IS NOT NULL AND `t`.`Name` <> ''
ON DUPLICATE KEY UPDATE `Name` = VALUES(`Name`), `VerifiedBuild` = VALUES(`VerifiedBuild`);
