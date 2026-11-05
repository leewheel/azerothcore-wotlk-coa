-- 物品描述（tooltip 名字下方那行绿字）补简体中文。
-- 服务端把 item_template_locale 的 Description 按会话语言发给客户端（ItemHandler.cpp SendItemQuerySingleResponse），
-- 主表 item_template.description 里的 @X@ 标记保持原样，飞升/血铸等逻辑仍按它判断。
-- 本文件只处理"整条描述就是一个标记"的物品；带额外英文说明的留给后续修订。
-- By leewheel 2026年11月05日

-- 神话等级：@Mythic 7@ → 神话 7
UPDATE `item_template_locale` l
JOIN `item_template` i ON i.`entry` = l.`ID`
SET l.`Description` = CONCAT('神话 ', SUBSTRING(i.`description`, 9, LENGTH(i.`description`) - 9))
WHERE l.`locale` = 'zhCN' AND IFNULL(l.`Description`, '') = ''
  AND i.`description` REGEXP '^@Mythic [0-9]+@$';
-- 套装等级：@Tier 4@ → 第 4 套
UPDATE `item_template_locale` l
JOIN `item_template` i ON i.`entry` = l.`ID`
SET l.`Description` = CONCAT('第 ', SUBSTRING(i.`description`, 7, LENGTH(i.`description`) - 7), ' 套')
WHERE l.`locale` = 'zhCN' AND IFNULL(l.`Description`, '') = ''
  AND i.`description` REGEXP '^@Tier [0-9.]+@$';

-- 副本前缀：@神话/英雄/飞升 + 副本名@
UPDATE `item_template_locale` l
JOIN `item_template` i ON i.`entry` = l.`ID`
SET l.`Description` = CONCAT(
    CASE SUBSTRING_INDEX(SUBSTRING(i.`description`, 2, LENGTH(i.`description`) - 2), ' ', 1)
      WHEN 'Mythic' THEN '神话' WHEN 'Heroic' THEN '英雄' WHEN 'Ascended' THEN '飞升' END, '·',
    CASE SUBSTRING(SUBSTRING(i.`description`, 2, LENGTH(i.`description`) - 2),
                   LOCATE(' ', SUBSTRING(i.`description`, 2, LENGTH(i.`description`) - 2)) + 1)
      WHEN 'Molten Core' THEN '熔火之心'
      WHEN 'Naxxramas' THEN '纳克萨玛斯'
      WHEN 'Temple of Ahn''Qiraj' THEN '安其拉神庙'
      WHEN 'Ruins of Ahn''Qiraj' THEN '安其拉废墟'
      WHEN 'Blackwing Lair' THEN '黑翼之巢'
      WHEN 'Zul''Gurub' THEN '祖尔格拉布'
      WHEN 'Onyxia' THEN '奥妮克希亚'
      WHEN 'Eye of Eternity' THEN '永恒之眼'
      WHEN 'The Obsidian Sanctum' THEN '黑曜石圣殿'
      WHEN 'Zul''Aman' THEN '祖阿曼'
      WHEN 'Magtheridon''s Lair' THEN '玛瑟里顿的巢穴'
      WHEN 'Karazhan' THEN '卡拉赞'
      WHEN 'Magisters'' Terrace' THEN '魔导师平台'
      WHEN 'Onyxia''s Lair' THEN '奥妮克希亚的巢穴'
      WHEN 'Raid' THEN '团队副本'
      WHEN 'Dungeon' THEN '地下城'
      WHEN 'World Boss' THEN '世界首领'
      WHEN 'Northrend World Drop' THEN '诺森德世界掉落'
      ELSE ''
    END)
WHERE l.`locale` = 'zhCN' AND IFNULL(l.`Description`, '') = ''
  AND i.`description` REGEXP '^@(Mythic|Heroic|Ascended) [A-Z]'
  AND i.`description` NOT REGEXP '^@(Mythic|Heroic|Ascended) [0-9]'
  AND i.`description` NOT LIKE '%: %';
-- End By leewheel

-- 团队副本名额：@Raid: Naxxramas - 25 Player@ → 团队副本：纳克萨玛斯 - 25 人
-- By leewheel 2026年11月05日
UPDATE `item_template_locale` l
JOIN `item_template` i ON i.`entry` = l.`ID`
SET l.`Description` = CONCAT('团队副本：',
    CASE SUBSTRING_INDEX(SUBSTRING(i.`description`, 8), ' - ', 1)
      WHEN 'Naxxramas' THEN '纳克萨玛斯'
      WHEN 'Eye of Eternity' THEN '永恒之眼'
      WHEN 'The Obsidian Sanctum' THEN '黑曜石圣殿'
      WHEN 'Onyxia' THEN '奥妮克希亚'
      WHEN 'Molten Core' THEN '熔火之心'
      WHEN 'Blackwing Lair' THEN '黑翼之巢'
      WHEN 'Zul''Gurub' THEN '祖尔格拉布'
      WHEN 'Temple of Ahn''Qiraj' THEN '安其拉神庙'
      WHEN 'Ruins of Ahn''Qiraj' THEN '安其拉废墟'
      WHEN 'Zul''Aman' THEN '祖阿曼'
      WHEN 'Magtheridon''s Lair' THEN '玛瑟里顿的巢穴'
      WHEN 'Karazhan' THEN '卡拉赞'
      WHEN 'The Mechanar' THEN '机械区'
      WHEN 'Mana-Tombs' THEN '法力陵墓'
      ELSE SUBSTRING_INDEX(SUBSTRING(i.`description`, 8), ' - ', 1)
    END, ' - ',
    SUBSTRING_INDEX(SUBSTRING_INDEX(i.`description`, ' - ', -1), ' Player', 1), ' 人')
WHERE l.`locale` = 'zhCN' AND IFNULL(l.`Description`, '') = ''
  AND i.`description` LIKE '@Raid: %' AND i.`description` LIKE '% Player@'
  AND i.`description` REGEXP '^@[^@]*@$';

-- 地下城：@Mythic Dungeon: 副本名@ / @Dungeon: 副本名@
UPDATE `item_template_locale` l
JOIN `item_template` i ON i.`entry` = l.`ID`
SET l.`Description` = CONCAT(
    CASE WHEN i.`description` LIKE '@Mythic Dungeon: %' THEN '神话地下城：'
         WHEN i.`description` LIKE '@Heroic Dungeon: %' THEN '英雄地下城：'
         ELSE '地下城：' END,
    CASE SUBSTRING_INDEX(SUBSTRING(i.`description`, 2, LENGTH(i.`description`) - 2), ': ', -1)
      WHEN 'Ahn''kahet, the Old Kingdom' THEN '安卡赫特：古代王国'
      WHEN 'Azjol-Nerub' THEN '艾卓-尼鲁布'
      WHEN 'Drak''Tharon Keep' THEN '达克萨隆要塞'
      WHEN 'Gundrak' THEN '古达克'
      WHEN 'Halls of Lightning' THEN '闪电大厅'
      WHEN 'Halls of Stone' THEN '岩石大厅'
      WHEN 'The Culling of Stratholme' THEN '斯坦索姆的抉择'
      WHEN 'The Nexus' THEN '魔枢'
      WHEN 'The Oculus' THEN '魔环'
      WHEN 'The Violet Hold' THEN '紫罗兰监狱'
      WHEN 'Utgarde Keep' THEN '乌特加德城堡'
      WHEN 'Utgarde Pinnacle' THEN '乌特加德之巅'
      WHEN 'Magisters'' Terrace' THEN '魔导师平台'
      WHEN 'The Steamvault' THEN '蒸汽池'
      WHEN 'The Arkat Trial' THEN '阿卡特定居点'
      WHEN 'Shadow Labyrinth' THEN '暗影迷宫'
      WHEN 'Sethekk Halls' THEN '塞泰克大厅'
      WHEN 'Auchenai Crypts' THEN '奥金尼地穴'
      WHEN 'Old Hillsbrad' THEN '旧希尔斯布莱德丘陵'
      WHEN 'The Black Morass' THEN '黑暗沼泽'
      ELSE SUBSTRING_INDEX(SUBSTRING(i.`description`, 2, LENGTH(i.`description`) - 2), ': ', -1)
    END)
WHERE l.`locale` = 'zhCN' AND IFNULL(l.`Description`, '') = ''
  AND i.`description` REGEXP '^@(Mythic |Heroic )?Dungeon: [A-Z]'
  AND i.`description` REGEXP '^@[^@]*@$';

-- 世界首领：@Heroic World Boss: Doomwalker@
UPDATE `item_template_locale` l
JOIN `item_template` i ON i.`entry` = l.`ID`
SET l.`Description` = CONCAT(
    CASE WHEN i.`description` LIKE '@Heroic World Boss%' THEN '英雄世界首领' ELSE '世界首领' END, '：',
    CASE SUBSTRING_INDEX(SUBSTRING(i.`description`, 2, LENGTH(i.`description`) - 2), ': ', -1)
      WHEN 'Doomwalker' THEN '末日行者'
      WHEN 'Doom Lord Kazzak' THEN '末日领主卡扎克'
      ELSE SUBSTRING_INDEX(SUBSTRING(i.`description`, 2, LENGTH(i.`description`) - 2), ': ', -1)
    END)
WHERE l.`locale` = 'zhCN' AND IFNULL(l.`Description`, '') = ''
  AND i.`description` LIKE '@%World Boss%'
  AND i.`description` REGEXP '^@[^@]*@$';
-- End By leewheel

-- 单词标记字典：品级、颜色、内部标记等直接整条替换（保留原有的颜色代码）。
-- By leewheel 2026年11月05日
UPDATE `item_template_locale` l
JOIN `item_template` i ON i.`entry` = l.`ID`
SET l.`Description` = CASE i.`description`
  WHEN '@|cFFCC0000Bloodforged|r@' THEN '|cFFCC0000血铸|r'
  WHEN '@|cFFCC0000Heroic Bloodforged|r@' THEN '|cFFCC0000英雄血铸|r'
  WHEN '@|cFFCC0000Sanguine|r@' THEN '|cFFCC0000猩红|r'
  WHEN '@|cffFFD700Prestigious|r@' THEN '|cffFFD700显赫|r'
  WHEN '@|cFFCC0000Bloodforged|r |cFF22FFFFFrozen Reach|r@' THEN '|cFFCC0000血铸|r |cFF22FFFF冰冻平原|r'
  WHEN '@|cFF22FFFFFrozen Reach|r@' THEN '|cFF22FFFF冰冻平原|r'
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
  WHEN '@Green@' THEN '绿色'
  WHEN '@Red@' THEN '红色'
  WHEN '@Blue@' THEN '蓝色'
  WHEN '@Purple@' THEN '紫色'
  WHEN '@Yellow@' THEN '黄色'
  WHEN '@Ascended Raid@' THEN '飞升团队副本'
  WHEN '@Mythic Raid@' THEN '神话团队副本'
  WHEN '@Heroic Raid@' THEN '英雄团队副本'
  WHEN '@Heroic Dungeon@' THEN '英雄地下城'
  WHEN '@Mythic Dungeon@' THEN '神话地下城'
  WHEN '@Karazhan Crypts Mythic@' THEN '卡拉赞地穴·神话'
  WHEN '@Karazhan Crypts - Mythic@' THEN '卡拉赞地穴·神话'
  WHEN '@Magisters'' Terrace Mythic@' THEN '魔导师平台·神话'
  WHEN '@Onyxia''s Lair Mythic@' THEN '奥妮克希亚的巢穴·神话'
  WHEN '@Emblem of Valor Quartermaster@' THEN '勇气徽记军需官'
  WHEN '@Northrend World Drop@' THEN '诺森德世界掉落'
  WHEN '@Heroic World Boss@' THEN '英雄世界首领'
  WHEN '@60@' THEN '60 级'
  ELSE ''
END
WHERE l.`locale` = 'zhCN' AND IFNULL(l.`Description`, '') = ''
  AND i.`description` IN ('@|cFFCC0000Bloodforged|r@', '@|cFFCC0000Heroic Bloodforged|r@',
    '@|cFFCC0000Sanguine|r@', '@|cffFFD700Prestigious|r@',
    '@|cFFCC0000Bloodforged|r |cFF22FFFFFrozen Reach|r@', '@|cFF22FFFFFrozen Reach|r@',
    '@Bloodforged@', '@Felforged@', '@Worldforged@', '@Mythic@', '@Heroic@', '@Fabled@',
    '@Refined@', '@Superior@', '@Masterwork@', '@Prestigious@', '@Base@', '@QA@',
    '@QA - Not For Player@', '@Green@', '@Red@', '@Blue@', '@Purple@', '@Yellow@',
    '@Ascended Raid@', '@Mythic Raid@', '@Heroic Raid@', '@Heroic Dungeon@', '@Mythic Dungeon@',
    '@Karazhan Crypts Mythic@', '@Karazhan Crypts - Mythic@', '@Magisters'' Terrace Mythic@',
    '@Onyxia''s Lair Mythic@', '@Emblem of Valor Quartermaster@', '@Northrend World Drop@',
    '@Heroic World Boss@', '@60@');
-- End By leewheel

-- 剩下的标记绝大多数是宠物/生物种类名（@Wolf@、@Black Scalebane@ 等），
-- 直接复用 creature_template_locale 里已有的简体中文生物名，保证和怪物名字一致。
-- By leewheel 2026年11月05日
UPDATE `item_template_locale` l
JOIN `item_template` i ON i.`entry` = l.`ID`
JOIN `creature_template` c ON c.`name` = SUBSTRING(i.`description`, 2, LENGTH(i.`description`) - 2)
JOIN `creature_template_locale` cl ON cl.`entry` = c.`entry` AND cl.`locale` = 'zhCN'
SET l.`Description` = cl.`Name`
WHERE l.`locale` = 'zhCN' AND IFNULL(l.`Description`, '') = ''
  AND IFNULL(cl.`Name`, '') <> ''
  AND i.`description` REGEXP '^@[^@]*@$';

-- 生物名表里查不到的种类名，按官方猎人宠物译名手工补齐。
UPDATE `item_template_locale` l
JOIN `item_template` i ON i.`entry` = l.`ID`
SET l.`Description` = CASE i.`description`
  WHEN '@Skeleton@' THEN '骷髅'
  WHEN '@Zombie@' THEN '僵尸'
  WHEN '@Wolf@' THEN '狼'
  WHEN '@Spider@' THEN '蜘蛛'
  WHEN '@Satyr@' THEN '萨特'
  WHEN '@Cat@' THEN '猫'
  WHEN '@Bear@' THEN '熊'
  WHEN '@Raptor@' THEN '迅猛龙'
  WHEN '@Boar@' THEN '野猪'
  WHEN '@Crab@' THEN '螃蟹'
  WHEN '@Crocolisk@' THEN '鳄鱼'
  WHEN '@Hyena@' THEN '鬣狗'
  WHEN '@Turtle@' THEN '乌龟'
  WHEN '@Worm@' THEN '虫'
  WHEN '@Wasp@' THEN '黄蜂'
  WHEN '@Bat@' THEN '蝙蝠'
  WHEN '@Moth@' THEN '飞蛾'
  WHEN '@Rhino@' THEN '犀牛'
  WHEN '@Serpent@' THEN '蛇'
  WHEN '@Devilsaur@' THEN '恶魔龙'
  WHEN '@Silithid@' THEN '异种蝎'
  WHEN '@Tallstrider@' THEN '高跷步行兽'
  WHEN '@Gorilla@' THEN '猩猩'
  WHEN '@Chimaera@' THEN '奇美拉'
  WHEN '@Wind Serpent@' THEN '风蛇'
  WHEN '@Carrion Bird@' THEN '食腐鸟'
  WHEN '@Bird of Prey@' THEN '猛禽'
  WHEN '@Nether Ray@' THEN '虚空鳐'
  WHEN '@Faerie Dragon@' THEN '精灵龙'
  WHEN '@Core Hound@' THEN '核心犬'
  WHEN '@Abomination@' THEN '憎恶'
  WHEN '@Ghoul@' THEN '食尸鬼'
  WHEN '@Wraith@' THEN '幽灵'
  WHEN '@Shade@' THEN '暗影'
  WHEN '@Banshee@' THEN '女妖'
  WHEN '@Wight@' THEN '亡魂'
  WHEN '@Crypt Fiend@' THEN '地穴魔'
  WHEN '@Crypt Lord@' THEN '地穴领主'
  WHEN '@Gargoyle@' THEN '石像鬼'
  WHEN '@Bone Golem@' THEN '骸骨魔像'
  WHEN '@Stone War Golem@' THEN '石头战争傀儡'
  WHEN '@Iron War Golem@' THEN '铁质战争傀儡'
  WHEN '@Water Elemental@' THEN '水元素'
  WHEN '@Earth Elemental@' THEN '土元素'
  WHEN '@Air Elemental@' THEN '风元素'
  WHEN '@Fire Elemental@' THEN '火焰元素'
  WHEN '@Mana Elemental@' THEN '法力元素'
  WHEN '@Magma Elemental@' THEN '熔岩元素'
  WHEN '@Arcane Elemental@' THEN '奥术元素'
  WHEN '@Ice Elemental@' THEN '冰元素'
  WHEN '@Entropic Elemental@' THEN '熵能元素'
  WHEN '@Infernal@' THEN '地狱火'
  WHEN '@Doomguard@' THEN '末日守卫'
  WHEN '@Shivarra@' THEN '希瓦娜'
  WHEN '@Nathrezim@' THEN '恐惧魔王'
  WHEN '@Pit Lord@' THEN '深渊领主'
  WHEN '@Wrathguard@' THEN '暴怒卫士'
  WHEN '@Terrorfiend@' THEN '惊怖魔'
  WHEN '@Ravager@' THEN '撕裂者'
  WHEN '@Observer@' THEN '观察者'
  WHEN '@Plague Eruptor@' THEN '瘟疫喷吐者'
  WHEN '@Skeletal Mage@' THEN '骷髅法师'
  WHEN '@Lasher@' THEN '鞭笞者'
  WHEN '@Hardwood Treant@' THEN '硬木树人'
  WHEN '@Dreadwood Treant@' THEN '恐惧木树人'
  WHEN '@Verdant Bog Beast@' THEN '翠绿泽地兽'
  WHEN '@Fungal Bog Beast@' THEN '真菌泽地兽'
  WHEN '@Black Scalebane@' THEN '黑色鳞片杀手'
  WHEN '@Red Scalebane@' THEN '红色鳞片杀手'
  WHEN '@Blue Scalebane@' THEN '蓝色鳞片杀手'
  WHEN '@Green Scalebane@' THEN '绿色鳞片杀手'
  WHEN '@Infinite Scalebane@' THEN '无限鳞片杀手'
  WHEN '@Black Wyrmkin@' THEN '黑色龙裔'
  WHEN '@Blue Wyrmkin@' THEN '蓝色龙裔'
  WHEN '@Green Wyrmkin@' THEN '绿色龙裔'
  WHEN '@Infinite Wyrmkin@' THEN '无限龙裔'
  WHEN '@Black Drakonid@' THEN '黑色龙人'
  WHEN '@Blue Drakonid@' THEN '蓝色龙人'
  WHEN '@Netherwing Drakonid@' THEN '虚空之翼龙人'
  WHEN '@Chromatic Drakonid@' THEN '多彩龙人'
  WHEN '@Black Drake@' THEN '黑色飞龙'
  WHEN '@Blue Drake@' THEN '蓝色飞龙'
  WHEN '@Green Drake@' THEN '绿色飞龙'
  WHEN '@Red Drake@' THEN '红色飞龙'
  WHEN '@Bronze Drake@' THEN '青铜飞龙'
  WHEN '@Netherwing Drake@' THEN '虚空之翼飞龙'
  WHEN '@Black Whelp@' THEN '黑色龙崽'
  WHEN '@Blue Whelp@' THEN '蓝色龙崽'
  WHEN '@Green Whelp@' THEN '绿色龙崽'
  WHEN '@Red Whelp@' THEN '红色龙崽'
  WHEN '@Bronze Whelp@' THEN '青铜龙崽'
  WHEN '@Twilight Whelp@' THEN '暮光龙崽'
  WHEN '@Black Dragon@' THEN '黑龙'
  WHEN '@Blue Dragon@' THEN '蓝龙'
  WHEN '@Green Dragon@' THEN '绿龙'
  WHEN '@Red Dragon@' THEN '红龙'
  WHEN '@Bronze Dragon@' THEN '青铜龙'
  WHEN '@Red Proto-dragon@' THEN '红色原龙'
  WHEN '@Blue Proto-dragon@' THEN '蓝色原龙'
  WHEN '@Man''ari Eredar@' THEN '玛纳瑞艾瑞达'
  WHEN '@Gan''arg@' THEN '甘阿格'
  WHEN '@Mo''arg Engineer@' THEN '莫阿格工程师'
  WHEN '@Air Revenant@' THEN '风之复仇亡魂'
  WHEN '@Water Revenant@' THEN '水之复仇亡魂'
  WHEN '@Fire Revenant@' THEN '火之复仇亡魂'
  WHEN '@Ruby Attrition@' THEN '红宝石磨损者'
  ELSE ''
END
WHERE l.`locale` = 'zhCN' AND IFNULL(l.`Description`, '') = ''
  AND i.`description` REGEXP '^@[^@]*@$'
  AND i.`description` IN ('@Skeleton@', '@Zombie@', '@Wolf@', '@Spider@', '@Satyr@', '@Cat@',
    '@Bear@', '@Raptor@', '@Boar@', '@Crab@', '@Crocolisk@', '@Hyena@', '@Turtle@', '@Worm@',
    '@Wasp@', '@Bat@', '@Moth@', '@Rhino@', '@Serpent@', '@Devilsaur@', '@Silithid@',
    '@Tallstrider@', '@Gorilla@', '@Chimaera@', '@Wind Serpent@', '@Carrion Bird@',
    '@Bird of Prey@', '@Nether Ray@', '@Faerie Dragon@', '@Core Hound@', '@Abomination@',
    '@Ghoul@', '@Wraith@', '@Shade@', '@Banshee@', '@Wight@', '@Crypt Fiend@', '@Crypt Lord@',
    '@Gargoyle@', '@Bone Golem@', '@Stone War Golem@', '@Iron War Golem@', '@Water Elemental@',
    '@Earth Elemental@', '@Air Elemental@', '@Fire Elemental@', '@Mana Elemental@',
    '@Magma Elemental@', '@Arcane Elemental@', '@Ice Elemental@', '@Entropic Elemental@',
    '@Infernal@', '@Doomguard@', '@Shivarra@', '@Nathrezim@', '@Pit Lord@', '@Wrathguard@',
    '@Terrorfiend@', '@Ravager@', '@Observer@', '@Plague Eruptor@', '@Skeletal Mage@',
    '@Lasher@', '@Hardwood Treant@', '@Dreadwood Treant@', '@Verdant Bog Beast@',
    '@Fungal Bog Beast@', '@Black Scalebane@', '@Red Scalebane@', '@Blue Scalebane@',
    '@Green Scalebane@', '@Infinite Scalebane@', '@Black Wyrmkin@', '@Blue Wyrmkin@',
    '@Green Wyrmkin@', '@Infinite Wyrmkin@', '@Black Drakonid@', '@Blue Drakonid@',
    '@Netherwing Drakonid@', '@Chromatic Drakonid@', '@Black Drake@', '@Blue Drake@',
    '@Green Drake@', '@Red Drake@', '@Bronze Drake@', '@Netherwing Drake@', '@Black Whelp@',
    '@Blue Whelp@', '@Green Whelp@', '@Red Whelp@', '@Bronze Whelp@', '@Twilight Whelp@',
    '@Black Dragon@', '@Blue Dragon@', '@Green Dragon@', '@Red Dragon@', '@Bronze Dragon@',
    '@Red Proto-dragon@', '@Blue Proto-dragon@', '@Man''ari Eredar@', '@Gan''arg@',
    '@Mo''arg Engineer@', '@Air Revenant@', '@Water Revenant@', '@Fire Revenant@',
    '@Ruby Attrition@');
-- End By leewheel

-- 等级区间：@40-49@ → 40-49 级
-- By leewheel 2026年11月05日
UPDATE `item_template_locale` l
JOIN `item_template` i ON i.`entry` = l.`ID`
SET l.`Description` = CONCAT(SUBSTRING(i.`description`, 2, LENGTH(i.`description`) - 2), ' 级')
WHERE l.`locale` = 'zhCN' AND IFNULL(l.`Description`, '') = ''
  AND i.`description` REGEXP '^@[0-9]+-[0-9]+@$';

-- 零散标记：颜色代码原样保留，只换里面的词。
UPDATE `item_template_locale` l
JOIN `item_template` i ON i.`entry` = l.`ID`
SET l.`Description` = CASE i.`description`
  WHEN '@Scorpid@' THEN '蝎'
  WHEN '@|cFFFF7F00Reborn|r@' THEN '|cFFFF7F00重生|r'
  WHEN '@|cFF00f3ffSeason 9 Supporter Pack|r@' THEN '|cFF00f3ff第九赛季支持者礼包|r'
  WHEN '@Infinite Drake@' THEN '无限飞龙'
  WHEN '@Chromatic Drake@' THEN '多彩飞龙'
  WHEN '@Chromatic Drakeadon@' THEN '多彩龙兽'
  WHEN '@Blue Aspect@' THEN '蓝色化身'
  WHEN '@Red Aspect@' THEN '红色化身'
  WHEN '@Bronze Scalebane@' THEN '青铜鳞片杀手'
  WHEN '@Chromatic Scalebane@' THEN '多彩鳞片杀手'
  WHEN '@Twilight Scalebane@' THEN '暮光鳞片杀手'
  WHEN '@Undead Quilboar@' THEN '亡灵野猪人'
  WHEN '@Celestial Dragonling@' THEN '天星幼龙'
  WHEN '@Infinite Drakonid@' THEN '无限龙人'
  WHEN '@Softwood Treant@' THEN '软木树人'
  WHEN '@Bronze Proto-dragon@' THEN '青铜原龙'
  WHEN '@Twilight Dragon@' THEN '暮光龙'
  WHEN '@Pseudo-dragon@' THEN '伪龙'
  WHEN '@Abyssal@' THEN '深渊魔'
  WHEN '@Spirit Beast@' THEN '灵魂兽'
  WHEN '@Enslaved Imp@' THEN '被奴役的小鬼'
  WHEN '@Mutated Orchid@' THEN '变异兰花'
  WHEN '@Earth Revenant@' THEN '土之复仇亡魂'
  WHEN '@Dark Iron War Golem@' THEN '黑铁战争傀儡'
  WHEN '@Stone Siege Golem@' THEN '石头攻城傀儡'
  WHEN '@Ragereaver War Golem@' THEN '暴怒者战争傀儡'
  WHEN '@Karazhan Crypts Heroic@' THEN '卡拉赞地穴·英雄'
  WHEN '@LFG Bonus Reward@' THEN '随机副本额外奖励'
  WHEN '@NOT A PVP ITEM@' THEN '非PVP物品'
  WHEN '@Metal@' THEN '金属'
  WHEN '@Gold@' THEN '黄金'
  WHEN '@Orange@' THEN '橙色'
  WHEN '@|cff00FF00Right Click to Open!|r@' THEN '|cff00FF00右键点击打开！|r'
  WHEN '@Raid: The Obsidian Sanctum - 10 Player - Twilight Assist@' THEN '团队副本：黑曜石圣殿 - 10 人 - 暮光协助'
  WHEN '@Raid: The Obsidian Sanctum - 10 Player - Twilight Duo@' THEN '团队副本：黑曜石圣殿 - 10 人 - 暮光双人'
  WHEN '@Raid: The Obsidian Sanctum - 25 Player - Twilight Assist@' THEN '团队副本：黑曜石圣殿 - 25 人 - 暮光协助'
  WHEN '@Raid: The Obsidian Sanctum - 25 Player - Twilight Duo@' THEN '团队副本：黑曜石圣殿 - 25 人 - 暮光双人'
  WHEN '@Raid: The Obsidian Sanctum - 10 Player - Twilight Zone@' THEN '团队副本：黑曜石圣殿 - 10 人 - 暮光领域'
  WHEN '@Raid: The Obsidian Sanctum - 25 Player - Twilight Zone@' THEN '团队副本：黑曜石圣殿 - 25 人 - 暮光领域'
  ELSE ''
END
WHERE l.`locale` = 'zhCN' AND IFNULL(l.`Description`, '') = ''
  AND i.`description` IN ('@Scorpid@', '@|cFFFF7F00Reborn|r@',
    '@|cFF00f3ffSeason 9 Supporter Pack|r@', '@Infinite Drake@', '@Chromatic Drake@',
    '@Chromatic Drakeadon@', '@Blue Aspect@', '@Red Aspect@', '@Bronze Scalebane@',
    '@Chromatic Scalebane@', '@Twilight Scalebane@', '@Undead Quilboar@',
    '@Celestial Dragonling@', '@Infinite Drakonid@', '@Softwood Treant@',
    '@Bronze Proto-dragon@', '@Twilight Dragon@', '@Pseudo-dragon@', '@Abyssal@',
    '@Spirit Beast@', '@Enslaved Imp@', '@Mutated Orchid@', '@Earth Revenant@',
    '@Dark Iron War Golem@', '@Stone Siege Golem@', '@Ragereaver War Golem@',
    '@Karazhan Crypts Heroic@', '@LFG Bonus Reward@', '@NOT A PVP ITEM@', '@Metal@',
    '@Gold@', '@Orange@', '@|cff00FF00Right Click to Open!|r@',
    '@Raid: The Obsidian Sanctum - 10 Player - Twilight Assist@',
    '@Raid: The Obsidian Sanctum - 10 Player - Twilight Duo@',
    '@Raid: The Obsidian Sanctum - 25 Player - Twilight Assist@',
    '@Raid: The Obsidian Sanctum - 25 Player - Twilight Duo@',
    '@Raid: The Obsidian Sanctum - 10 Player - Twilight Zone@',
    '@Raid: The Obsidian Sanctum - 25 Player - Twilight Zone@');
-- End By leewheel


