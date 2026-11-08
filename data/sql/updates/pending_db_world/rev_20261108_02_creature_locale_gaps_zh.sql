-- 2026-11-08 补全本轮 SQL 涉及生物的简体中文名与头衔（By leewheel）
-- 触发：抽查 rev_20261106_280_coa_eliza_narsingway_stable_master_11393 后做全量审计，
--       发现下列生物在 creature_template 有英文名/英文头衔，但 creature_template_locale 缺 zhCN 行。
-- 覆盖：本轮全部 SQL（34 条 world）涉及的 124 个生物，逐个核对后仅以下对象缺行。

-- 1) 缺中文名（7 个；[UNUSED] 150 属废弃占位，不处理）
INSERT INTO `creature_template_locale` (`entry`, `locale`, `Name`, `Title`, `VerifiedBuild`) VALUES
(1,      'zhCN', '路径点（仅 GM 可见）', '视觉标记', 12340),
(110940, 'zhCN', '哀嚎编织者',           NULL,       12340),
(590007, 'zhCN', '卡斯卡德',             '凛冬之患', 12340),
(590008, 'zhCN', '外科医生缝肉',         '狂人',     12340),
(590015, 'zhCN', '阿德拉努斯',           '熔岩元素', 12340),
(590019, 'zhCN', '铁石斯纳皮',           NULL,       12340),
(918563, 'zhCN', '被奴役的异种虫',       NULL,       12340),
(918690, 'zhCN', '冰铸元素',             NULL,       12340)
ON DUPLICATE KEY UPDATE `Name` = VALUES(`Name`), `Title` = VALUES(`Title`), `VerifiedBuild` = VALUES(`VerifiedBuild`);

-- 2) 有中文名但缺中文头衔（黑市工匠补给商 14 名 + 贪婪恶魔的「经典」标签）
UPDATE `creature_template_locale` SET `Title` = '黑市工匠补给'
WHERE `locale` = 'zhCN' AND `entry` IN (970000, 970001, 970002, 970004, 970006, 970011,
                                        970013, 970020, 970022, 970024, 970031, 970034, 970038, 970042);

UPDATE `creature_template_locale` SET `Title` = '经典'
WHERE `locale` = 'zhCN' AND `entry` = 75121;
