-- 物品描述（tooltip 名字下方那行）补简体中文。
-- 服务端按会话语言把 item_template_locale.Description 发给客户端（ItemHandler.cpp 的 SendItemQuerySingleResponse），
-- 主表 item_template.description 里的 @X@ 标记保持原样，飞升/血铸等判定仍读主表。
-- 本文件只处理"整条描述就是一个标记"的物品；标记后还带英文说明的留给后续修订。
-- By leewheel 2026年11月05日

-- 品级与内部标记。颜色代码 |cRRGGBB...|r 原样保留，只换里面的词。
UPDATE `item_template_locale` AS `l`
JOIN `item_template` AS `i` ON `i`.`entry` = `l`.`ID`
SET `l`.`Description` = CASE `i`.`description`
    WHEN '@|cFFCC0000Bloodforged|r@' THEN '|cFFCC0000血铸|r'
    WHEN '@|cFFCC0000Heroic Bloodforged|r@' THEN '|cFFCC0000英雄血铸|r'
    WHEN '@|cFFCC0000Sanguine|r@' THEN '|cFFCC0000猩红|r'
    WHEN '@|cffFFD700Prestigious|r@' THEN '|cffFFD700显赫|r'
    WHEN '@|cFFCC0000Bloodforged|r |cFF22FFFFFrozen Reach|r@' THEN '|cFFCC0000血铸|r |cFF22FFFF冰冻平原|r'
    WHEN '@|cFF22FFFFFrozen Reach|r@' THEN '|cFF22FFFF冰冻平原|r'
    WHEN '@|cFFFF7F00Reborn|r@' THEN '|cFFFF7F00重生|r'
    WHEN '@|cFF00f3ffSeason 9 Supporter Pack|r@' THEN '|cFF00f3ff第九赛季支持者礼包|r'
    WHEN '@|cff00FF00Right Click to Open!|r@' THEN '|cff00FF00右键点击打开！|r'
    WHEN '@Bloodforged@' THEN '血铸'
    WHEN '@Felforged@' THEN '邪能铸'
    WHEN '@Worldforged@' THEN '世界铸造'
    WHEN '@Mythic@' THEN '神话'
    WHEN '@Heroic@' THEN '英雄'
    WHEN '@Fabled@' THEN '传说'
    WHEN '@Refined@' THEN '精制'
    WHEN '@Superior@' THEN '精良'
    WHEN '@Masterwork@' THEN '杰作'
    WHEN '@Prestigious@' THEN '显赫'
    WHEN '@Base@' THEN '基础'
    WHEN '@QA@' THEN '测试物品'
    WHEN '@QA - Not For Player@' THEN '测试物品·不发玩家'
    WHEN '@NOT A PVP ITEM@' THEN '非PVP物品'
    WHEN '@LFG Bonus Reward@' THEN '随机副本额外奖励'
    WHEN '@Emblem of Valor Quartermaster@' THEN '勇气徽记军需官'
    WHEN '@Green@' THEN '绿色'
    WHEN '@Red@' THEN '红色'
    WHEN '@Blue@' THEN '蓝色'
    WHEN '@Purple@' THEN '紫色'
    WHEN '@Yellow@' THEN '黄色'
    WHEN '@Orange@' THEN '橙色'
    WHEN '@Gold@' THEN '黄金'
    WHEN '@Metal@' THEN '金属'
    WHEN '@60@' THEN '60 级'
    WHEN '@Ascended Raid@' THEN '飞升团队副本'
    WHEN '@Mythic Raid@' THEN '神话团队副本'
    WHEN '@Heroic Raid@' THEN '英雄团队副本'
    WHEN '@Heroic Dungeon@' THEN '英雄地下城'
    WHEN '@Mythic Dungeon@' THEN '神话地下城'
    WHEN '@Heroic World Boss@' THEN '英雄世界首领'
    WHEN '@Northrend World Drop@' THEN '诺森德世界掉落'
    WHEN '@Karazhan Crypts Mythic@' THEN '卡拉赞地穴·神话'
    WHEN '@Karazhan Crypts - Mythic@' THEN '卡拉赞地穴·神话'
    WHEN '@Karazhan Crypts Heroic@' THEN '卡拉赞地穴·英雄'
    WHEN '@Magisters'' Terrace Mythic@' THEN '魔导师平台·神话'
    WHEN '@Onyxia''s Lair Mythic@' THEN '奥妮克希亚的巢穴·神话'
    ELSE ''
END
WHERE `l`.`locale` = 'zhCN'
  AND (`l`.`Description` = '' OR `l`.`Description` IS NULL)
  AND `i`.`description` IN ('@|cFFCC0000Bloodforged|r@', '@|cFFCC0000Heroic Bloodforged|r@',
    '@|cFFCC0000Sanguine|r@', '@|cffFFD700Prestigious|r@',
    '@|cFFCC0000Bloodforged|r |cFF22FFFFFrozen Reach|r@', '@|cFF22FFFFFrozen Reach|r@',
    '@|cFFFF7F00Reborn|r@', '@|cFF00f3ffSeason 9 Supporter Pack|r@',
    '@|cff00FF00Right Click to Open!|r@', '@Bloodforged@', '@Felforged@', '@Worldforged@',
    '@Mythic@', '@Heroic@', '@Fabled@', '@Refined@', '@Superior@', '@Masterwork@',
    '@Prestigious@', '@Base@', '@QA@', '@QA - Not For Player@', '@NOT A PVP ITEM@',
    '@LFG Bonus Reward@', '@Emblem of Valor Quartermaster@', '@Green@', '@Red@', '@Blue@',
    '@Purple@', '@Yellow@', '@Orange@', '@Gold@', '@Metal@', '@60@', '@Ascended Raid@',
    '@Mythic Raid@', '@Heroic Raid@', '@Heroic Dungeon@', '@Mythic Dungeon@',
    '@Heroic World Boss@', '@Northrend World Drop@', '@Karazhan Crypts Mythic@',
    '@Karazhan Crypts - Mythic@', '@Karazhan Crypts Heroic@', '@Magisters'' Terrace Mythic@',
    '@Onyxia''s Lair Mythic@');
-- End By leewheel

-- 神话等级 @Mythic 1@ - @Mythic 100@。
-- By leewheel 2026年11月05日
UPDATE `item_template_locale` AS `l`
JOIN `item_template` AS `i` ON `i`.`entry` = `l`.`ID`
SET `l`.`Description` = CASE `i`.`description`
    WHEN '@Mythic 1@' THEN '神话 1' WHEN '@Mythic 2@' THEN '神话 2' WHEN '@Mythic 3@' THEN '神话 3' WHEN '@Mythic 4@' THEN '神话 4' WHEN '@Mythic 5@' THEN '神话 5'
    WHEN '@Mythic 6@' THEN '神话 6' WHEN '@Mythic 7@' THEN '神话 7' WHEN '@Mythic 8@' THEN '神话 8' WHEN '@Mythic 9@' THEN '神话 9' WHEN '@Mythic 10@' THEN '神话 10'
    WHEN '@Mythic 11@' THEN '神话 11' WHEN '@Mythic 12@' THEN '神话 12' WHEN '@Mythic 13@' THEN '神话 13' WHEN '@Mythic 14@' THEN '神话 14' WHEN '@Mythic 15@' THEN '神话 15'
    WHEN '@Mythic 16@' THEN '神话 16' WHEN '@Mythic 17@' THEN '神话 17' WHEN '@Mythic 18@' THEN '神话 18' WHEN '@Mythic 19@' THEN '神话 19' WHEN '@Mythic 20@' THEN '神话 20'
    WHEN '@Mythic 21@' THEN '神话 21' WHEN '@Mythic 22@' THEN '神话 22' WHEN '@Mythic 23@' THEN '神话 23' WHEN '@Mythic 24@' THEN '神话 24' WHEN '@Mythic 25@' THEN '神话 25'
    WHEN '@Mythic 26@' THEN '神话 26' WHEN '@Mythic 27@' THEN '神话 27' WHEN '@Mythic 28@' THEN '神话 28' WHEN '@Mythic 29@' THEN '神话 29' WHEN '@Mythic 30@' THEN '神话 30'
    WHEN '@Mythic 31@' THEN '神话 31' WHEN '@Mythic 32@' THEN '神话 32' WHEN '@Mythic 33@' THEN '神话 33' WHEN '@Mythic 34@' THEN '神话 34' WHEN '@Mythic 35@' THEN '神话 35'
    WHEN '@Mythic 36@' THEN '神话 36' WHEN '@Mythic 37@' THEN '神话 37' WHEN '@Mythic 38@' THEN '神话 38' WHEN '@Mythic 39@' THEN '神话 39' WHEN '@Mythic 40@' THEN '神话 40'
    WHEN '@Mythic 41@' THEN '神话 41' WHEN '@Mythic 42@' THEN '神话 42' WHEN '@Mythic 43@' THEN '神话 43' WHEN '@Mythic 44@' THEN '神话 44' WHEN '@Mythic 45@' THEN '神话 45'
    WHEN '@Mythic 46@' THEN '神话 46' WHEN '@Mythic 47@' THEN '神话 47' WHEN '@Mythic 48@' THEN '神话 48' WHEN '@Mythic 49@' THEN '神话 49' WHEN '@Mythic 50@' THEN '神话 50'
    WHEN '@Mythic 51@' THEN '神话 51' WHEN '@Mythic 52@' THEN '神话 52' WHEN '@Mythic 53@' THEN '神话 53' WHEN '@Mythic 54@' THEN '神话 54' WHEN '@Mythic 55@' THEN '神话 55'
    WHEN '@Mythic 56@' THEN '神话 56' WHEN '@Mythic 57@' THEN '神话 57' WHEN '@Mythic 58@' THEN '神话 58' WHEN '@Mythic 59@' THEN '神话 59' WHEN '@Mythic 60@' THEN '神话 60'
    WHEN '@Mythic 61@' THEN '神话 61' WHEN '@Mythic 62@' THEN '神话 62' WHEN '@Mythic 63@' THEN '神话 63' WHEN '@Mythic 64@' THEN '神话 64' WHEN '@Mythic 65@' THEN '神话 65'
    WHEN '@Mythic 66@' THEN '神话 66' WHEN '@Mythic 67@' THEN '神话 67' WHEN '@Mythic 68@' THEN '神话 68' WHEN '@Mythic 69@' THEN '神话 69' WHEN '@Mythic 70@' THEN '神话 70'
    WHEN '@Mythic 71@' THEN '神话 71' WHEN '@Mythic 72@' THEN '神话 72' WHEN '@Mythic 73@' THEN '神话 73' WHEN '@Mythic 74@' THEN '神话 74' WHEN '@Mythic 75@' THEN '神话 75'
    WHEN '@Mythic 76@' THEN '神话 76' WHEN '@Mythic 77@' THEN '神话 77' WHEN '@Mythic 78@' THEN '神话 78' WHEN '@Mythic 79@' THEN '神话 79' WHEN '@Mythic 80@' THEN '神话 80'
    WHEN '@Mythic 81@' THEN '神话 81' WHEN '@Mythic 82@' THEN '神话 82' WHEN '@Mythic 83@' THEN '神话 83' WHEN '@Mythic 84@' THEN '神话 84' WHEN '@Mythic 85@' THEN '神话 85'
    WHEN '@Mythic 86@' THEN '神话 86' WHEN '@Mythic 87@' THEN '神话 87' WHEN '@Mythic 88@' THEN '神话 88' WHEN '@Mythic 89@' THEN '神话 89' WHEN '@Mythic 90@' THEN '神话 90'
    WHEN '@Mythic 91@' THEN '神话 91' WHEN '@Mythic 92@' THEN '神话 92' WHEN '@Mythic 93@' THEN '神话 93' WHEN '@Mythic 94@' THEN '神话 94' WHEN '@Mythic 95@' THEN '神话 95'
    WHEN '@Mythic 96@' THEN '神话 96' WHEN '@Mythic 97@' THEN '神话 97' WHEN '@Mythic 98@' THEN '神话 98' WHEN '@Mythic 99@' THEN '神话 99' WHEN '@Mythic 100@' THEN '神话 100'
    ELSE ''
END
WHERE `l`.`locale` = 'zhCN'
  AND (`l`.`Description` = '' OR `l`.`Description` IS NULL)
  AND `i`.`description` IN ('@Mythic 1@', '@Mythic 2@', '@Mythic 3@', '@Mythic 4@', '@Mythic 5@',
    '@Mythic 6@', '@Mythic 7@', '@Mythic 8@', '@Mythic 9@', '@Mythic 10@', '@Mythic 11@',
    '@Mythic 12@', '@Mythic 13@', '@Mythic 14@', '@Mythic 15@', '@Mythic 16@', '@Mythic 17@',
    '@Mythic 18@', '@Mythic 19@', '@Mythic 20@', '@Mythic 21@', '@Mythic 22@', '@Mythic 23@',
    '@Mythic 24@', '@Mythic 25@', '@Mythic 26@', '@Mythic 27@', '@Mythic 28@', '@Mythic 29@',
    '@Mythic 30@', '@Mythic 31@', '@Mythic 32@', '@Mythic 33@', '@Mythic 34@', '@Mythic 35@',
    '@Mythic 36@', '@Mythic 37@', '@Mythic 38@', '@Mythic 39@', '@Mythic 40@', '@Mythic 41@',
    '@Mythic 42@', '@Mythic 43@', '@Mythic 44@', '@Mythic 45@', '@Mythic 46@', '@Mythic 47@',
    '@Mythic 48@', '@Mythic 49@', '@Mythic 50@', '@Mythic 51@', '@Mythic 52@', '@Mythic 53@',
    '@Mythic 54@', '@Mythic 55@', '@Mythic 56@', '@Mythic 57@', '@Mythic 58@', '@Mythic 59@',
    '@Mythic 60@', '@Mythic 61@', '@Mythic 62@', '@Mythic 63@', '@Mythic 64@', '@Mythic 65@',
    '@Mythic 66@', '@Mythic 67@', '@Mythic 68@', '@Mythic 69@', '@Mythic 70@', '@Mythic 71@',
    '@Mythic 72@', '@Mythic 73@', '@Mythic 74@', '@Mythic 75@', '@Mythic 76@', '@Mythic 77@',
    '@Mythic 78@', '@Mythic 79@', '@Mythic 80@', '@Mythic 81@', '@Mythic 82@', '@Mythic 83@',
    '@Mythic 84@', '@Mythic 85@', '@Mythic 86@', '@Mythic 87@', '@Mythic 88@', '@Mythic 89@',
    '@Mythic 90@', '@Mythic 91@', '@Mythic 92@', '@Mythic 93@', '@Mythic 94@', '@Mythic 95@',
    '@Mythic 96@', '@Mythic 97@', '@Mythic 98@', '@Mythic 99@', '@Mythic 100@');
-- End By leewheel

-- 套装等级 @Tier N@ 与物品等级区间。
-- By leewheel 2026年11月05日
UPDATE `item_template_locale` AS `l`
JOIN `item_template` AS `i` ON `i`.`entry` = `l`.`ID`
SET `l`.`Description` = CASE `i`.`description`
    WHEN '@Tier 1@' THEN '第 1 套' WHEN '@Tier 2@' THEN '第 2 套' WHEN '@Tier 3@' THEN '第 3 套' WHEN '@Tier 4@' THEN '第 4 套' WHEN '@Tier 5@' THEN '第 5 套'
    WHEN '@Tier 6@' THEN '第 6 套' WHEN '@Tier 7@' THEN '第 7 套' WHEN '@Tier 8@' THEN '第 8 套' WHEN '@Tier 9@' THEN '第 9 套' WHEN '@Tier 10@' THEN '第 10 套'
    WHEN '@Tier 11@' THEN '第 11 套' WHEN '@Tier 12@' THEN '第 12 套' WHEN '@Tier 13@' THEN '第 13 套' WHEN '@Tier 14@' THEN '第 14 套' WHEN '@Tier 15@' THEN '第 15 套'
    WHEN '@Tier 16@' THEN '第 16 套' WHEN '@Tier 17@' THEN '第 17 套' WHEN '@Tier 18@' THEN '第 18 套' WHEN '@Tier 19@' THEN '第 19 套' WHEN '@Tier 20@' THEN '第 20 套'
    WHEN '@Tier 21@' THEN '第 21 套' WHEN '@Tier 22@' THEN '第 22 套' WHEN '@Tier 23@' THEN '第 23 套' WHEN '@Tier 24@' THEN '第 24 套' WHEN '@Tier 25@' THEN '第 25 套'
    WHEN '@1-59@' THEN '1-59 级' WHEN '@5-15@' THEN '5-15 级' WHEN '@10-19@' THEN '10-19 级' WHEN '@16-25@' THEN '16-25 级' WHEN '@20-29@' THEN '20-29 级'
    WHEN '@26-34@' THEN '26-34 级' WHEN '@26-35@' THEN '26-35 级' WHEN '@30-39@' THEN '30-39 级' WHEN '@35-45@' THEN '35-45 级' WHEN '@36-45@' THEN '36-45 级'
    WHEN '@40-49@' THEN '40-49 级' WHEN '@46-55@' THEN '46-55 级' WHEN '@50-60@' THEN '50-60 级' WHEN '@56-60@' THEN '56-60 级' WHEN '@61-64@' THEN '61-64 级'
    WHEN '@61-70@' THEN '61-70 级' WHEN '@65-70@' THEN '65-70 级' WHEN '@71-80@' THEN '71-80 级' WHEN '@10-25@' THEN '10-25 级' WHEN '@201-300@' THEN '201-300 级'
    WHEN '@501-550@' THEN '501-550 级' WHEN '@801-900@' THEN '801-900 级' WHEN '@1301-1400@' THEN '1301-1400 级' WHEN '@1501-1600@' THEN '1501-1600 级'
    ELSE ''
END
WHERE `l`.`locale` = 'zhCN'
  AND (`l`.`Description` = '' OR `l`.`Description` IS NULL)
  AND `i`.`description` IN ('@Tier 1@', '@Tier 2@', '@Tier 3@', '@Tier 4@', '@Tier 5@', '@Tier 6@',
    '@Tier 7@', '@Tier 8@', '@Tier 9@', '@Tier 10@', '@Tier 11@', '@Tier 12@', '@Tier 13@',
    '@Tier 14@', '@Tier 15@', '@Tier 16@', '@Tier 17@', '@Tier 18@', '@Tier 19@', '@Tier 20@',
    '@Tier 21@', '@Tier 22@', '@Tier 23@', '@Tier 24@', '@Tier 25@', '@1-59@', '@5-15@',
    '@10-19@', '@16-25@', '@20-29@', '@26-34@', '@26-35@', '@30-39@', '@35-45@', '@36-45@',
    '@40-49@', '@46-55@', '@50-60@', '@56-60@', '@61-64@', '@61-70@', '@65-70@', '@71-80@',
    '@10-25@', '@201-300@', '@501-550@', '@801-900@', '@1301-1400@', '@1501-1600@');
-- End By leewheel

-- 副本前缀组合：@Mythic Molten Core@、@Heroic Dungeon: 副本名@、@Raid: 副本名 - N Player@ 等。
-- By leewheel 2026年11月05日
UPDATE `item_template_locale` AS `l`
JOIN `item_template` AS `i` ON `i`.`entry` = `l`.`ID`
SET `l`.`Description` = CASE `i`.`description`
    WHEN '@Mythic Molten Core@' THEN '神话·熔火之心' WHEN '@Heroic Molten Core@' THEN '英雄·熔火之心' WHEN '@Ascended Molten Core@' THEN '飞升·熔火之心'
    WHEN '@Mythic Naxxramas@' THEN '神话·纳克萨玛斯' WHEN '@Heroic Naxxramas@' THEN '英雄·纳克萨玛斯' WHEN '@Ascended Naxxramas@' THEN '飞升·纳克萨玛斯'
    WHEN '@Mythic Blackwing Lair@' THEN '神话·黑翼之巢' WHEN '@Heroic Blackwing Lair@' THEN '英雄·黑翼之巢' WHEN '@Ascended Blackwing Lair@' THEN '飞升·黑翼之巢'
    WHEN '@Mythic Temple of Ahn''Qiraj@' THEN '神话·安其拉神庙' WHEN '@Heroic Temple of Ahn''Qiraj@' THEN '英雄·安其拉神庙' WHEN '@Ascended Temple of Ahn''Qiraj@' THEN '飞升·安其拉神庙'
    WHEN '@Mythic Ruins of Ahn''Qiraj@' THEN '神话·安其拉废墟' WHEN '@Heroic Ruins of Ahn''Qiraj@' THEN '英雄·安其拉废墟' WHEN '@Ascended Ruins of Ahn''Qiraj@' THEN '飞升·安其拉废墟'
    WHEN '@Mythic Zul''Gurub@' THEN '神话·祖尔格拉布' WHEN '@Heroic Zul''Gurub@' THEN '英雄·祖尔格拉布' WHEN '@Ascended Zul''Gurub@' THEN '飞升·祖尔格拉布'
    WHEN '@Mythic Onyxia@' THEN '神话·奥妮克希亚' WHEN '@Heroic Onyxia@' THEN '英雄·奥妮克希亚' WHEN '@Ascended Onyxia@' THEN '飞升·奥妮克希亚'
    WHEN '@Raid: Naxxramas - 10 Player@' THEN '团队副本：纳克萨玛斯 - 10 人'
    WHEN '@Raid: Naxxramas - 25 Player@' THEN '团队副本：纳克萨玛斯 - 25 人'
    WHEN '@Raid: Eye of Eternity - 10 Player@' THEN '团队副本：永恒之眼 - 10 人'
    WHEN '@Raid: Eye of Eternity - 25 Player@' THEN '团队副本：永恒之眼 - 25 人'
    WHEN '@Raid: The Obsidian Sanctum@' THEN '团队副本：黑曜石圣殿'
    WHEN '@Raid: The Obsidian Sanctum - 10 Player@' THEN '团队副本：黑曜石圣殿 - 10 人'
    WHEN '@Raid: The Obsidian Sanctum - 25 Player@' THEN '团队副本：黑曜石圣殿 - 25 人'
    WHEN '@Raid: The Obsidian Sanctum - 10 Player - Twilight Assist@' THEN '团队副本：黑曜石圣殿 - 10 人 - 暮光协助'
    WHEN '@Raid: The Obsidian Sanctum - 10 Player - Twilight Duo@' THEN '团队副本：黑曜石圣殿 - 10 人 - 暮光双人'
    WHEN '@Raid: The Obsidian Sanctum - 10 Player - Twilight Zone@' THEN '团队副本：黑曜石圣殿 - 10 人 - 暮光领域'
    WHEN '@Raid: The Obsidian Sanctum - 25 Player - Twilight Assist@' THEN '团队副本：黑曜石圣殿 - 25 人 - 暮光协助'
    WHEN '@Raid: The Obsidian Sanctum - 25 Player - Twilight Duo@' THEN '团队副本：黑曜石圣殿 - 25 人 - 暮光双人'
    WHEN '@Raid: The Obsidian Sanctum - 25 Player - Twilight Zone@' THEN '团队副本：黑曜石圣殿 - 25 人 - 暮光领域'
    WHEN '@Heroic World Boss: Doomwalker@' THEN '英雄世界首领：末日行者'
    WHEN '@Heroic World Boss: Doom Lord Kazzak@' THEN '英雄世界首领：末日领主卡扎克'
    ELSE ''
END
WHERE `l`.`locale` = 'zhCN'
  AND (`l`.`Description` = '' OR `l`.`Description` IS NULL)
  AND `i`.`description` IN ('@Mythic Molten Core@', '@Heroic Molten Core@', '@Ascended Molten Core@',
    '@Mythic Naxxramas@', '@Heroic Naxxramas@', '@Ascended Naxxramas@', '@Mythic Blackwing Lair@',
    '@Heroic Blackwing Lair@', '@Ascended Blackwing Lair@', '@Mythic Temple of Ahn''Qiraj@',
    '@Heroic Temple of Ahn''Qiraj@', '@Ascended Temple of Ahn''Qiraj@', '@Mythic Ruins of Ahn''Qiraj@',
    '@Heroic Ruins of Ahn''Qiraj@', '@Ascended Ruins of Ahn''Qiraj@', '@Mythic Zul''Gurub@',
    '@Heroic Zul''Gurub@', '@Ascended Zul''Gurub@', '@Mythic Onyxia@', '@Heroic Onyxia@',
    '@Ascended Onyxia@', '@Raid: Naxxramas - 10 Player@', '@Raid: Naxxramas - 25 Player@',
    '@Raid: Eye of Eternity - 10 Player@', '@Raid: Eye of Eternity - 25 Player@',
    '@Raid: The Obsidian Sanctum@', '@Raid: The Obsidian Sanctum - 10 Player@',
    '@Raid: The Obsidian Sanctum - 25 Player@', '@Raid: The Obsidian Sanctum - 10 Player - Twilight Assist@',
    '@Raid: The Obsidian Sanctum - 10 Player - Twilight Duo@', '@Raid: The Obsidian Sanctum - 10 Player - Twilight Zone@',
    '@Raid: The Obsidian Sanctum - 25 Player - Twilight Assist@', '@Raid: The Obsidian Sanctum - 25 Player - Twilight Duo@',
    '@Raid: The Obsidian Sanctum - 25 Player - Twilight Zone@', '@Heroic World Boss: Doomwalker@',
    '@Heroic World Boss: Doom Lord Kazzak@');
-- End By leewheel

-- 地下城标记：@Dungeon: 副本名@ / @Heroic Dungeon: 副本名@ / @Mythic Dungeon: 副本名@。
-- By leewheel 2026年11月05日
UPDATE `item_template_locale` AS `l`
JOIN `item_template` AS `i` ON `i`.`entry` = `l`.`ID`
SET `l`.`Description` = CASE `i`.`description`
    WHEN '@Dungeon: Ahn''kahet, the Old Kingdom@' THEN '地下城：安卡赫特：古代王国' WHEN '@Heroic Dungeon: Ahn''kahet, the Old Kingdom@' THEN '英雄地下城：安卡赫特：古代王国' WHEN '@Mythic Dungeon: Ahn''kahet, the Old Kingdom@' THEN '神话地下城：安卡赫特：古代王国'
    WHEN '@Dungeon: Azjol-Nerub@' THEN '地下城：艾卓-尼鲁布' WHEN '@Heroic Dungeon: Azjol-Nerub@' THEN '英雄地下城：艾卓-尼鲁布' WHEN '@Mythic Dungeon: Azjol-Nerub@' THEN '神话地下城：艾卓-尼鲁布'
    WHEN '@Dungeon: Drak''Tharon Keep@' THEN '地下城：达克萨隆要塞' WHEN '@Heroic Dungeon: Drak''Tharon Keep@' THEN '英雄地下城：达克萨隆要塞' WHEN '@Mythic Dungeon: Drak''Tharon Keep@' THEN '神话地下城：达克萨隆要塞'
    WHEN '@Dungeon: Gundrak@' THEN '地下城：古达克' WHEN '@Heroic Dungeon: Gundrak@' THEN '英雄地下城：古达克' WHEN '@Mythic Dungeon: Gundrak@' THEN '神话地下城：古达克'
    WHEN '@Dungeon: Halls of Lightning@' THEN '地下城：闪电大厅' WHEN '@Heroic Dungeon: Halls of Lightning@' THEN '英雄地下城：闪电大厅' WHEN '@Mythic Dungeon: Halls of Lightning@' THEN '神话地下城：闪电大厅'
    WHEN '@Dungeon: Halls of Stone@' THEN '地下城：岩石大厅' WHEN '@Heroic Dungeon: Halls of Stone@' THEN '英雄地下城：岩石大厅' WHEN '@Mythic Dungeon: Halls of Stone@' THEN '神话地下城：岩石大厅'
    WHEN '@Dungeon: The Culling of Stratholme@' THEN '地下城：斯坦索姆的抉择' WHEN '@Heroic Dungeon: The Culling of Stratholme@' THEN '英雄地下城：斯坦索姆的抉择' WHEN '@Mythic Dungeon: The Culling of Stratholme@' THEN '神话地下城：斯坦索姆的抉择'
    WHEN '@Dungeon: The Nexus@' THEN '地下城：魔枢' WHEN '@Heroic Dungeon: The Nexus@' THEN '英雄地下城：魔枢' WHEN '@Mythic Dungeon: The Nexus@' THEN '神话地下城：魔枢'
    WHEN '@Dungeon: The Oculus@' THEN '地下城：魔环' WHEN '@Heroic Dungeon: The Oculus@' THEN '英雄地下城：魔环' WHEN '@Mythic Dungeon: The Oculus@' THEN '神话地下城：魔环'
    WHEN '@Dungeon: The Violet Hold@' THEN '地下城：紫罗兰监狱' WHEN '@Heroic Dungeon: The Violet Hold@' THEN '英雄地下城：紫罗兰监狱' WHEN '@Mythic Dungeon: The Violet Hold@' THEN '神话地下城：紫罗兰监狱'
    WHEN '@Dungeon: Utgarde Keep@' THEN '地下城：乌特加德城堡' WHEN '@Heroic Dungeon: Utgarde Keep@' THEN '英雄地下城：乌特加德城堡' WHEN '@Mythic Dungeon: Utgarde Keep@' THEN '神话地下城：乌特加德城堡'
    WHEN '@Dungeon: Utgarde Pinnacle@' THEN '地下城：乌特加德之巅' WHEN '@Heroic Dungeon: Utgarde Pinnacle@' THEN '英雄地下城：乌特加德之巅' WHEN '@Mythic Dungeon: Utgarde Pinnacle@' THEN '神话地下城：乌特加德之巅'
    ELSE ''
END
WHERE `l`.`locale` = 'zhCN'
  AND (`l`.`Description` = '' OR `l`.`Description` IS NULL)
  AND `i`.`description` LIKE '@%Dungeon: %@';
-- End By leewheel

-- 生物种类名：逐个列出标记，译名与 creature_template_locale 的中文生物名保持一致。
-- By leewheel 2026年11月05日
UPDATE `item_template_locale` AS `l`
JOIN `item_template` AS `i` ON `i`.`entry` = `l`.`ID`
SET `l`.`Description` = CASE `i`.`description`
    WHEN '@Scorpid@' THEN '蝎' WHEN '@Skeleton@' THEN '骷髅' WHEN '@Zombie@' THEN '僵尸' WHEN '@Wolf@' THEN '狼' WHEN '@Spider@' THEN '蜘蛛'
    WHEN '@Satyr@' THEN '萨特' WHEN '@Cat@' THEN '猫' WHEN '@Bear@' THEN '熊' WHEN '@Raptor@' THEN '迅猛龙' WHEN '@Boar@' THEN '野猪'
    WHEN '@Crab@' THEN '螃蟹' WHEN '@Crocolisk@' THEN '鳄鱼' WHEN '@Hyena@' THEN '鬣狗' WHEN '@Turtle@' THEN '乌龟' WHEN '@Worm@' THEN '蠕虫'
    WHEN '@Wasp@' THEN '黄蜂' WHEN '@Bat@' THEN '蝙蝠' WHEN '@Moth@' THEN '蛾' WHEN '@Rhino@' THEN '犀牛' WHEN '@Serpent@' THEN '蛇'
    WHEN '@Devilsaur@' THEN '恶魔龙' WHEN '@Silithid@' THEN '异种蝎' WHEN '@Tallstrider@' THEN '高跷兽' WHEN '@Gorilla@' THEN '猩猩'
    WHEN '@Chimaera@' THEN '奇美拉' WHEN '@Wind Serpent@' THEN '风蛇' WHEN '@Carrion Bird@' THEN '食腐鸟' WHEN '@Bird of Prey@' THEN '猛禽'
    WHEN '@Nether Ray@' THEN '虚空鳐' WHEN '@Faerie Dragon@' THEN '精灵龙' WHEN '@Core Hound@' THEN '核心犬' WHEN '@Abomination@' THEN '憎恶'
    WHEN '@Ghoul@' THEN '食尸鬼' WHEN '@Wraith@' THEN '幽灵' WHEN '@Shade@' THEN '暗影' WHEN '@Banshee@' THEN '女妖' WHEN '@Wight@' THEN '亡魂'
    WHEN '@Crypt Fiend@' THEN '地穴魔' WHEN '@Crypt Lord@' THEN '地穴领主' WHEN '@Gargoyle@' THEN '石像鬼' WHEN '@Bone Golem@' THEN '骸骨魔像'
    WHEN '@Stone War Golem@' THEN '石头战争傀儡' WHEN '@Iron War Golem@' THEN '铁质战争傀儡' WHEN '@Dark Iron War Golem@' THEN '黑铁战争傀儡'
    WHEN '@Stone Siege Golem@' THEN '石头攻城傀儡' WHEN '@Ragereaver War Golem@' THEN '暴怒者战争傀儡' WHEN '@Mutated Orchid@' THEN '变异兰花'
    WHEN '@Water Elemental@' THEN '水元素' WHEN '@Earth Elemental@' THEN '土元素' WHEN '@Air Elemental@' THEN '风元素' WHEN '@Fire Elemental@' THEN '火焰元素'
    WHEN '@Mana Elemental@' THEN '法力元素' WHEN '@Magma Elemental@' THEN '熔岩元素' WHEN '@Arcane Elemental@' THEN '奥术元素' WHEN '@Ice Elemental@' THEN '冰元素'
    WHEN '@Entropic Elemental@' THEN '熵能元素' WHEN '@Infernal@' THEN '地狱火' WHEN '@Doomguard@' THEN '末日守卫' WHEN '@Shivarra@' THEN '希瓦娜'
    WHEN '@Nathrezim@' THEN '恐惧魔王' WHEN '@Pit Lord@' THEN '深渊领主' WHEN '@Wrathguard@' THEN '暴怒卫士' WHEN '@Terrorfiend@' THEN '惊怖魔'
    WHEN '@Ravager@' THEN '撕裂者' WHEN '@Observer@' THEN '观察者' WHEN '@Plague Eruptor@' THEN '瘟疫喷吐者' WHEN '@Skeletal Mage@' THEN '骷髅法师'
    WHEN '@Lasher@' THEN '鞭笞者' WHEN '@Hardwood Treant@' THEN '硬木树人' WHEN '@Dreadwood Treant@' THEN '恐惧木树人' WHEN '@Softwood Treant@' THEN '软木树人'
    WHEN '@Verdant Bog Beast@' THEN '翠绿泽地兽' WHEN '@Fungal Bog Beast@' THEN '真菌泽地兽' WHEN '@Undead Quilboar@' THEN '亡灵野猪人'
    WHEN '@Spirit Beast@' THEN '灵魂兽' WHEN '@Enslaved Imp@' THEN '被奴役的小鬼' WHEN '@Abyssal@' THEN '深渊魔' WHEN '@Celestial Dragonling@' THEN '天星幼龙'
    WHEN '@Black Scalebane@' THEN '黑色鳞片杀手' WHEN '@Red Scalebane@' THEN '红色鳞片杀手' WHEN '@Blue Scalebane@' THEN '蓝色鳞片杀手'
    WHEN '@Green Scalebane@' THEN '绿色鳞片杀手' WHEN '@Bronze Scalebane@' THEN '青铜鳞片杀手' WHEN '@Chromatic Scalebane@' THEN '多彩鳞片杀手'
    WHEN '@Twilight Scalebane@' THEN '暮光鳞片杀手' WHEN '@Infinite Scalebane@' THEN '无限鳞片杀手'
    WHEN '@Black Wyrmkin@' THEN '黑色龙裔' WHEN '@Blue Wyrmkin@' THEN '蓝色龙裔' WHEN '@Green Wyrmkin@' THEN '绿色龙裔' WHEN '@Infinite Wyrmkin@' THEN '无限龙裔'
    WHEN '@Black Drakonid@' THEN '黑色龙人' WHEN '@Blue Drakonid@' THEN '蓝色龙人' WHEN '@Netherwing Drakonid@' THEN '虚空之翼龙人'
    WHEN '@Chromatic Drakonid@' THEN '多彩龙人' WHEN '@Infinite Drakonid@' THEN '无限龙人'
    WHEN '@Black Drake@' THEN '黑色飞龙' WHEN '@Blue Drake@' THEN '蓝色飞龙' WHEN '@Green Drake@' THEN '绿色飞龙' WHEN '@Red Drake@' THEN '红色飞龙'
    WHEN '@Bronze Drake@' THEN '青铜飞龙' WHEN '@Infinite Drake@' THEN '无限飞龙' WHEN '@Chromatic Drake@' THEN '多彩飞龙'
    WHEN '@Chromatic Drakeadon@' THEN '多彩龙兽' WHEN '@Netherwing Drake@' THEN '虚空之翼飞龙' WHEN '@Twilight Dragon@' THEN '暮光龙'
    WHEN '@Black Whelp@' THEN '黑色龙崽' WHEN '@Blue Whelp@' THEN '蓝色龙崽' WHEN '@Green Whelp@' THEN '绿色龙崽' WHEN '@Red Whelp@' THEN '红色龙崽'
    WHEN '@Bronze Whelp@' THEN '青铜龙崽' WHEN '@Twilight Whelp@' THEN '暮光龙崽'
    WHEN '@Black Dragon@' THEN '黑龙' WHEN '@Blue Dragon@' THEN '蓝龙' WHEN '@Green Dragon@' THEN '绿龙' WHEN '@Red Dragon@' THEN '红龙' WHEN '@Bronze Dragon@' THEN '青铜龙'
    WHEN '@Red Proto-dragon@' THEN '红色原龙' WHEN '@Blue Proto-dragon@' THEN '蓝色原龙' WHEN '@Bronze Proto-dragon@' THEN '青铜原龙' WHEN '@Pseudo-dragon@' THEN '伪龙'
    WHEN '@Blue Aspect@' THEN '蓝色化身' WHEN '@Red Aspect@' THEN '红色化身'
    WHEN '@Man''ari Eredar@' THEN '玛纳瑞艾瑞达' WHEN '@Gan''arg@' THEN '甘阿格' WHEN '@Mo''arg Engineer@' THEN '莫阿格工程师'
    WHEN '@Air Revenant@' THEN '风之复仇亡魂' WHEN '@Water Revenant@' THEN '水之复仇亡魂' WHEN '@Fire Revenant@' THEN '火之复仇亡魂' WHEN '@Earth Revenant@' THEN '土之复仇亡魂'
    WHEN '@Ruby Attrition@' THEN '红宝石磨损者'
    ELSE ''
END
WHERE `l`.`locale` = 'zhCN'
  AND (`l`.`Description` = '' OR `l`.`Description` IS NULL)
  AND `i`.`description` IN ('@Scorpid@', '@Skeleton@', '@Zombie@', '@Wolf@', '@Spider@', '@Satyr@',
    '@Cat@', '@Bear@', '@Raptor@', '@Boar@', '@Crab@', '@Crocolisk@', '@Hyena@', '@Turtle@',
    '@Worm@', '@Wasp@', '@Bat@', '@Moth@', '@Rhino@', '@Serpent@', '@Devilsaur@', '@Silithid@',
    '@Tallstrider@', '@Gorilla@', '@Chimaera@', '@Wind Serpent@', '@Carrion Bird@',
    '@Bird of Prey@', '@Nether Ray@', '@Faerie Dragon@', '@Core Hound@', '@Abomination@',
    '@Ghoul@', '@Wraith@', '@Shade@', '@Banshee@', '@Wight@', '@Crypt Fiend@', '@Crypt Lord@',
    '@Gargoyle@', '@Bone Golem@', '@Stone War Golem@', '@Iron War Golem@', '@Dark Iron War Golem@',
    '@Stone Siege Golem@', '@Ragereaver War Golem@', '@Mutated Orchid@', '@Water Elemental@',
    '@Earth Elemental@', '@Air Elemental@', '@Fire Elemental@', '@Mana Elemental@',
    '@Magma Elemental@', '@Arcane Elemental@', '@Ice Elemental@', '@Entropic Elemental@',
    '@Infernal@', '@Doomguard@', '@Shivarra@', '@Nathrezim@', '@Pit Lord@', '@Wrathguard@',
    '@Terrorfiend@', '@Ravager@', '@Observer@', '@Plague Eruptor@', '@Skeletal Mage@',
    '@Lasher@', '@Hardwood Treant@', '@Dreadwood Treant@', '@Softwood Treant@',
    '@Verdant Bog Beast@', '@Fungal Bog Beast@', '@Undead Quilboar@', '@Spirit Beast@',
    '@Enslaved Imp@', '@Abyssal@', '@Celestial Dragonling@', '@Black Scalebane@',
    '@Red Scalebane@', '@Blue Scalebane@', '@Green Scalebane@', '@Bronze Scalebane@',
    '@Chromatic Scalebane@', '@Twilight Scalebane@', '@Infinite Scalebane@', '@Black Wyrmkin@',
    '@Blue Wyrmkin@', '@Green Wyrmkin@', '@Infinite Wyrmkin@', '@Black Drakonid@',
    '@Blue Drakonid@', '@Netherwing Drakonid@', '@Chromatic Drakonid@', '@Infinite Drakonid@',
    '@Black Drake@', '@Blue Drake@', '@Green Drake@', '@Red Drake@', '@Bronze Drake@',
    '@Infinite Drake@', '@Chromatic Drake@', '@Chromatic Drakeadon@', '@Netherwing Drake@',
    '@Twilight Dragon@', '@Black Whelp@', '@Blue Whelp@', '@Green Whelp@', '@Red Whelp@',
    '@Bronze Whelp@', '@Twilight Whelp@', '@Black Dragon@', '@Blue Dragon@', '@Green Dragon@',
    '@Red Dragon@', '@Bronze Dragon@', '@Red Proto-dragon@', '@Blue Proto-dragon@',
    '@Bronze Proto-dragon@', '@Pseudo-dragon@', '@Blue Aspect@', '@Red Aspect@',
    '@Man''ari Eredar@', '@Gan''arg@', '@Mo''arg Engineer@', '@Air Revenant@',
    '@Water Revenant@', '@Fire Revenant@', '@Earth Revenant@', '@Ruby Attrition@');
-- End By leewheel

-- 收尾：其余颜色、龙裔/傀儡族名、等级段、以及带颜色代码的团本标记。
-- @build:xxx@ 与 @re:编号@ 是内部引用占位符，不是玩家可见文案，保持原样。
-- By leewheel 2026年11月05日
UPDATE `item_template_locale` AS `l`
JOIN `item_template` AS `i` ON `i`.`entry` = `l`.`ID`
SET `l`.`Description` = CASE `i`.`description`
    WHEN '@Cyan@' THEN '青色' WHEN '@Teal@' THEN '蓝绿' WHEN '@Pink@' THEN '粉色' WHEN '@Magenta@' THEN '品红'
    WHEN '@Classic@' THEN '经典旧世' WHEN '@Test@' THEN '测试' WHEN '@Wrath of the Lich King@' THEN '巫妖王之怒'
    WHEN '@Hexxed - Mastercraft@' THEN '巫咒·杰作'
    WHEN '@Heroic Bloodforged@' THEN '英雄血铸'
    WHEN '@Contains one of the newest released legendary enchantments!@' THEN '内含一件最新发布的传说附魔！'
    WHEN '@Onyxia''s Lair Ascended@' THEN '奥妮克希亚的巢穴·飞升' WHEN '@Onyxia''s Lair Heroic@' THEN '奥妮克希亚的巢穴·英雄'
    WHEN '@|cFF00f3ffLeague 5 Supporter Pack|r@' THEN '|cFF00f3ff第五联盟支持者礼包|r'
    WHEN '@|cFF1EFF00Heroic Dungeon|r@' THEN '|cFF1EFF00英雄地下城|r'
    WHEN '@|cFFFF8000Ancient Ascended|r@' THEN '|cFFFF8000远古飞升|r'
    WHEN '@|cFFFF8000Ascended Raid|r@' THEN '|cFFFF8000飞升团队副本|r'
    WHEN '@|cFFFF8000Ascended|r@' THEN '|cFFFF8000飞升|r'
    WHEN '@|cFFFF8000Heroic Raid|r@' THEN '|cFFFF8000英雄团队副本|r'
    WHEN '@Black Aspect@' THEN '黑色化身' WHEN '@Infinite Dragon@' THEN '无限龙' WHEN '@Netherwing Dragon@' THEN '虚空之翼龙'
    WHEN '@Frostbrood@' THEN '冰霜龙裔' WHEN '@Twilight Drake@' THEN '暮光飞龙' WHEN '@Plagued Whelp@' THEN '瘟疫龙崽'
    WHEN '@Chromatic Whelp@' THEN '多彩龙崽' WHEN '@Infinite Whelp@' THEN '无限龙崽' WHEN '@Red Wyrmkin@' THEN '红色龙裔'
    WHEN '@Bronze Wyrmkin@' THEN '青铜龙裔' WHEN '@Green Drakonid@' THEN '绿色龙人' WHEN '@Red Drakonid@' THEN '红色龙人'
    WHEN '@Bronze Drakonid@' THEN '青铜龙人' WHEN '@Black Proto-dragon@' THEN '黑色原龙' WHEN '@Infinite Proto-dragon@' THEN '无限原龙'
    WHEN '@Twilight Proto-dragon@' THEN '暮光原龙'
    WHEN '@Drakkari War Golem@' THEN '达卡里战争傀儡' WHEN '@Runic War Golem@' THEN '符文战争傀儡'
    WHEN '@Runic Siege Golem@' THEN '符文攻城傀儡' WHEN '@Molten War Golem@' THEN '熔火战争傀儡'
    WHEN '@Molten Siege Golem@' THEN '熔岩攻城傀儡' WHEN '@Ragereaver Siege Golem@' THEN '暴怒者攻城傀儡'
    WHEN '@Bloodpetal Lasher@' THEN '血瓣鞭笞者' WHEN '@Deathpetal Lasher@' THEN '死瓣鞭笞者' WHEN '@Frostpetal Lasher@' THEN '霜瓣鞭笞者'
    WHEN '@Constrictor Lasher@' THEN '缠绕鞭笞者' WHEN '@Constrictor Orchid@' THEN '缠绕兰花' WHEN '@Frostpetal Orchid@' THEN '霜瓣兰花'
    WHEN '@Winterwood Treant@' THEN '冬木树人' WHEN '@Darkhound@' THEN '黑暗猎犬' WHEN '@Ghost@' THEN '鬼魂' WHEN '@Mummy@' THEN '木乃伊'
    WHEN '@Lich@' THEN '巫妖' WHEN '@Phoenix@' THEN '凤凰' WHEN '@Dog@' THEN '犬' WHEN '@Elekk@' THEN '雷象'
    WHEN '@Dragonhawk@' THEN '龙鹰' WHEN '@Sporebat@' THEN '孢子蝠' WHEN '@Warp Stalker@' THEN '曲域捕食者'
    WHEN '@Void Terror@' THEN '虚空恐魔' WHEN '@Fel Beast@' THEN '邪能兽' WHEN '@Thunder Lizard@' THEN '雷蜥'
    WHEN '@Dreadsteed@' THEN '恐惧战马' WHEN '@Felsteed@' THEN '恶魔战马' WHEN '@Steam Elemental@' THEN '蒸汽元素'
    WHEN '@Mojo Elemental@' THEN '活力元素' WHEN '@Ice Revenant@' THEN '冰之复仇亡魂' WHEN '@Death Revenant@' THEN '死亡复仇亡魂'
    WHEN '@10-29 Win@' THEN '10-29 级胜场' WHEN '@20-29 Win@' THEN '20-29 级胜场' WHEN '@30-39 Win@' THEN '30-39 级胜场'
    WHEN '@40-49 Win@' THEN '40-49 级胜场' WHEN '@50-60 Win@' THEN '50-60 级胜场' WHEN '@61-70 Win@' THEN '61-70 级胜场'
    WHEN '@71-80 Win@' THEN '71-80 级胜场'
    WHEN '@401 - 450@' THEN '401-450 级' WHEN '@651 - 700@' THEN '651-700 级' WHEN '@951 - 1000@' THEN '951-1000 级'
    WHEN '@1201 - 1250@' THEN '1201-1250 级' WHEN '@1501 - 1550@' THEN '1501-1550 级' WHEN '@1751 - 1800@' THEN '1751-1800 级'
    WHEN '@1951 - 2000+@' THEN '1951-2000+ 级'
    ELSE ''
END
WHERE `l`.`locale` = 'zhCN'
  AND (`l`.`Description` = '' OR `l`.`Description` IS NULL)
  AND `i`.`description` IN ('@Cyan@', '@Teal@', '@Pink@', '@Magenta@', '@Classic@', '@Test@',
    '@Wrath of the Lich King@', '@Hexxed - Mastercraft@', '@Heroic Bloodforged@',
    '@Contains one of the newest released legendary enchantments!@', '@Onyxia''s Lair Ascended@',
    '@Onyxia''s Lair Heroic@', '@|cFF00f3ffLeague 5 Supporter Pack|r@',
    '@|cFF1EFF00Heroic Dungeon|r@', '@|cFFFF8000Ancient Ascended|r@', '@|cFFFF8000Ascended Raid|r@',
    '@|cFFFF8000Ascended|r@', '@|cFFFF8000Heroic Raid|r@', '@Black Aspect@', '@Infinite Dragon@',
    '@Netherwing Dragon@', '@Frostbrood@', '@Twilight Drake@', '@Plagued Whelp@',
    '@Chromatic Whelp@', '@Infinite Whelp@', '@Red Wyrmkin@', '@Bronze Wyrmkin@',
    '@Green Drakonid@', '@Red Drakonid@', '@Bronze Drakonid@', '@Black Proto-dragon@',
    '@Infinite Proto-dragon@', '@Twilight Proto-dragon@', '@Drakkari War Golem@',
    '@Runic War Golem@', '@Runic Siege Golem@', '@Molten War Golem@', '@Molten Siege Golem@',
    '@Ragereaver Siege Golem@', '@Bloodpetal Lasher@', '@Deathpetal Lasher@',
    '@Frostpetal Lasher@', '@Constrictor Lasher@', '@Constrictor Orchid@', '@Frostpetal Orchid@',
    '@Winterwood Treant@', '@Darkhound@', '@Ghost@', '@Mummy@', '@Lich@', '@Phoenix@', '@Dog@',
    '@Elekk@', '@Dragonhawk@', '@Sporebat@', '@Warp Stalker@', '@Void Terror@', '@Fel Beast@',
    '@Thunder Lizard@', '@Dreadsteed@', '@Felsteed@', '@Steam Elemental@', '@Mojo Elemental@',
    '@Ice Revenant@', '@Death Revenant@', '@10-29 Win@', '@20-29 Win@', '@30-39 Win@',
    '@40-49 Win@', '@50-60 Win@', '@61-70 Win@', '@71-80 Win@', '@401 - 450@', '@651 - 700@',
    '@951 - 1000@', '@1201 - 1250@', '@1501 - 1550@', '@1751 - 1800@', '@1951 - 2000+@');
-- End By leewheel
