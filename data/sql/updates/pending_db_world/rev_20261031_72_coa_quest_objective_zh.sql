-- 死灵法师入门任务(200040/200043/200046/200049/200052)目标文本汉化
-- 修任务日志目标"Find the ritual circle"英文残留(Title/Details 已汉化,仅 ObjectiveText1 缺)
-- By leewheel 20261031
UPDATE `quest_template_locale` SET `ObjectiveText1` = '找到仪式法阵并与之互动。'
WHERE `ID` IN (200040, 200043, 200046, 200049, 200052) AND `locale` = 'zhCN';
