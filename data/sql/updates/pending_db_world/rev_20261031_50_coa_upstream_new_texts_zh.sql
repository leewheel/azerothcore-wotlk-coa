-- 上游合并新增玩家可见文本汉化（apex hunts 任务/皮料、法力风暴 S10 宝箱、珍宝守护者）
-- 术语沿用库内既有译名：Nytharos=尼萨罗斯 / Stormfang=风暴之牙 / Vaelthara=薇尔萨拉
-- Manastorm Cache 既有风格：法力风暴宝箱：X //By leewheel 2026年10月30日
DELETE FROM `creature_template_locale` WHERE `locale`='zhCN' AND `entry` IN (900026, 9916113, 9916114);
REPLACE INTO `creature_template_locale` SET `entry`=900026, `locale`='zhCN', `Name`='法力风暴珍宝守护者', `Title`='';
REPLACE INTO `creature_template_locale` SET `entry`=9916113, `locale`='zhCN', `Name`='托瓦德·灰羽', `Title`='狩猎大师';
REPLACE INTO `creature_template_locale` SET `entry`=9916114, `locale`='zhCN', `Name`='祖尔卡', `Title`='狩猎大师';

DELETE FROM `item_template_locale` WHERE `locale`='zhCN' AND `ID` IN (1009302, 1009303, 1009304, 1278059, 1278061, 1278063, 1278064, 1278065, 1278067, 1278072, 1278073, 1278074, 1278076, 1278082);
REPLACE INTO `item_template_locale` SET `ID`=1009302, `locale`='zhCN', `Name`='风暴之牙的毛皮', `Description`='';
REPLACE INTO `item_template_locale` SET `ID`=1009303, `locale`='zhCN', `Name`='伤疤枭猫毛皮', `Description`='';
REPLACE INTO `item_template_locale` SET `ID`=1009304, `locale`='zhCN', `Name`='潮蚀兽皮', `Description`='';
REPLACE INTO `item_template_locale` SET `ID`=1278059, `locale`='zhCN', `Name`='法力风暴宝箱：史诗 1-10 层', `Description`='';
REPLACE INTO `item_template_locale` SET `ID`=1278061, `locale`='zhCN', `Name`='法力风暴宝箱：奥妮克希亚与熔火之心', `Description`='';
REPLACE INTO `item_template_locale` SET `ID`=1278063, `locale`='zhCN', `Name`='法力风暴宝箱：英雄奥妮克希亚与熔火之心', `Description`='';
REPLACE INTO `item_template_locale` SET `ID`=1278064, `locale`='zhCN', `Name`='法力风暴宝箱：史诗 11-20 层', `Description`='';
REPLACE INTO `item_template_locale` SET `ID`=1278065, `locale`='zhCN', `Name`='法力风暴宝箱：史诗奥妮克希亚与熔火之心', `Description`='';
REPLACE INTO `item_template_locale` SET `ID`=1278067, `locale`='zhCN', `Name`='法力风暴宝箱：飞升奥妮克希亚与熔火之心', `Description`='';
REPLACE INTO `item_template_locale` SET `ID`=1278072, `locale`='zhCN', `Name`='法力风暴宝箱：英雄安其拉废墟', `Description`='';
REPLACE INTO `item_template_locale` SET `ID`=1278073, `locale`='zhCN', `Name`='法力风暴宝箱：史诗 21-30 层', `Description`='';
REPLACE INTO `item_template_locale` SET `ID`=1278074, `locale`='zhCN', `Name`='法力风暴宝箱：史诗安其拉废墟', `Description`='';
REPLACE INTO `item_template_locale` SET `ID`=1278076, `locale`='zhCN', `Name`='法力风暴宝箱：飞升安其拉废墟', `Description`='';
REPLACE INTO `item_template_locale` SET `ID`=1278082, `locale`='zhCN', `Name`='法力风暴宝箱：史诗 31-40 层', `Description`='';

DELETE FROM `quest_template_locale` WHERE `Locale`='zhCN' AND `ID` IN (17839, 17844);
REPLACE INTO `quest_template_locale` SET `ID`=17839, `Locale`='zhCN',
`Title`='三大巅峰狩猎',
`Details`='我在这片大陆上追猎过三头野兽，每一次都铩羽而归。输给的不是它们的獠牙，而是它们的耐心。尼萨罗斯蛰伏在淹没的废墟里，让大海替他动手。风暴之牙沿辛特兰的山脊游走，从不停留到能被你击中的时候。薇尔萨拉被食人魔追猎了二十年，反过来学会了狩猎。把它们的毛皮带给我，亲手剥下。是不是你亲自动手的，我看得出来。',
`Objectives`='将尼萨罗斯、风暴之牙和薇尔萨拉的毛皮带给暴风城矮人区的托瓦德·灰羽。',
`EndText`='',
`CompletedText`='回到暴风城矮人区的托瓦德·灰羽那里。',
`ObjectiveText1`='', `ObjectiveText2`='', `ObjectiveText3`='', `ObjectiveText4`='';
REPLACE INTO `quest_template_locale` SET `ID`=17844, `Locale`='zhCN',
`Title`='三大巅峰狩猎',
`Details`='有三头野兽顶着艾泽拉斯最好的毛皮。淹死鬼尼萨罗斯。他不追你，他等你，水会替他杀你。风暴之牙，风暴狼。他动起来像闪电，打人也像。伤疤母兽薇尔萨拉。食人魔猎了她二十年，现在她猎一切。杀掉它们。亲手剥皮。从猎人手里买来的皮，那不叫皮，那叫皮革。',
`Objectives`='将尼萨罗斯、风暴之牙和薇尔萨拉的毛皮带给奥格瑞玛荣誉谷的祖尔卡。',
`EndText`='',
`CompletedText`='回到奥格瑞玛荣誉谷的祖尔卡那里。',
`ObjectiveText1`='', `ObjectiveText2`='', `ObjectiveText3`='', `ObjectiveText4`='';
