-- 任务残留汉化：254099 补 zhCN locale 行 + 10 条原版任务 ObjectiveText 英文修复
-- By leewheel 20261031
START TRANSACTION;

INSERT IGNORE INTO `quest_template_locale` (`ID`, `locale`, `Title`, `Details`, `Objectives`, `EndText`, `CompletedText`, `ObjectiveText1`, `ObjectiveText2`, `ObjectiveText3`, `ObjectiveText4`, `VerifiedBuild`) VALUES
(254099, 'zhCN', '测试混合剂', '喝下"强化"矿泉水，检查是否会出现不良反应。', '', '', '', '', '', '', '', 0);

UPDATE `quest_template_locale` SET `ObjectiveText1` = '协助消灭虚空行者' WHERE `ID` = 9384 AND `locale` = 'zhCN';
UPDATE `quest_template_locale` SET `ObjectiveText1` = '营救远征队研究员' WHERE `ID` = 9749 AND `locale` = 'zhCN';
UPDATE `quest_template_locale` SET `ObjectiveText1` = '调查沙拉斯的防御' WHERE `ID` = 9958 AND `locale` = 'zhCN';
UPDATE `quest_template_locale` SET `ObjectiveText1` = '调查沙拉斯的防御' WHERE `ID` = 9959 AND `locale` = 'zhCN';
UPDATE `quest_template_locale` SET `ObjectiveText2` = '解救戴罗姆' WHERE `ID` = 9980 AND `locale` = 'zhCN';
UPDATE `quest_template_locale` SET `ObjectiveText2` = '解救杜加尔' WHERE `ID` = 9981 AND `locale` = 'zhCN';
UPDATE `quest_template_locale` SET `ObjectiveText1` = '保持绿色速度 6 秒' WHERE `ID` = 11320 AND `locale` = 'zhCN';
UPDATE `quest_template_locale` SET `ObjectiveText2` = '保持黄色速度 6 秒' WHERE `ID` = 11320 AND `locale` = 'zhCN';
UPDATE `quest_template_locale` SET `ObjectiveText3` = '保持红色速度 6 秒' WHERE `ID` = 11320 AND `locale` = 'zhCN';
UPDATE `quest_template_locale` SET `ObjectiveText1` = '工作中' WHERE `ID` = 12911 AND `locale` = 'zhCN';
UPDATE `quest_template_locale` SET `ObjectiveText1` = '完成成就：诺森德博学者' WHERE `ID` = 13299 AND `locale` = 'zhCN';
UPDATE `quest_template_locale` SET `ObjectiveText1` = '完成成就：诺森德博学者' WHERE `ID` = 13303 AND `locale` = 'zhCN';
COMMIT;
