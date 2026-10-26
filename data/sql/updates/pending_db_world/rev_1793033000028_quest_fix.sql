-- By leewheel 2026年10月26日
-- 修复两类 quest 校验错误：
-- 1) "Quest X has `StartItem` = Y but `StartItemCount` = 0, set to 1"——
--    核心的 StartItemCount 对应 quest_template_addon.ProvidedItemCount（第 17 列）。
--    6 个有 addon 行的置 1；8 个缺 addon 行的补插（其余列取默认 0，与缺行默认等效）。
-- 2) "has `RequiredNpcOrGoN` = X but creature with entry X does not exist"——
--    1660081/1660082/1660088 的 6 条击杀目标生物不存在，清空对应 Req/Count 对。
-- 备份：Tempfiles/db_backup_20261026/backup_round2d_20261026.txt

UPDATE quest_template_addon SET ProvidedItemCount = 1 WHERE ID IN (176003, 176004, 176013, 176014, 999914, 999933);

INSERT IGNORE INTO quest_template_addon
(ID, MaxLevel, AllowableClasses, SourceSpellID, PrevQuestID, NextQuestID, ExclusiveGroup,
 BreadcrumbForQuestId, RewardMailTemplateID, RewardMailDelay, RequiredSkillID, RequiredSkillPoints,
 RequiredMinRepFaction, RequiredMaxRepFaction, RequiredMinRepValue, RequiredMaxRepValue,
 ProvidedItemCount, SpecialFlags)
VALUES
(200012, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(200024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(175331, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(200057, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(175350, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(200013, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(200113, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(9302412, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0);

UPDATE quest_template SET RequiredNpcOrGo1 = 0, RequiredNpcOrGoCount1 = 0 WHERE ID = 1660081;

UPDATE quest_template SET RequiredNpcOrGo1 = 0, RequiredNpcOrGoCount1 = 0,
    RequiredNpcOrGo2 = 0, RequiredNpcOrGoCount2 = 0,
    RequiredNpcOrGo3 = 0, RequiredNpcOrGoCount3 = 0,
    RequiredNpcOrGo4 = 0, RequiredNpcOrGoCount4 = 0
WHERE ID = 1660082;

UPDATE quest_template SET RequiredNpcOrGo1 = 0, RequiredNpcOrGoCount1 = 0 WHERE ID = 1660088;
