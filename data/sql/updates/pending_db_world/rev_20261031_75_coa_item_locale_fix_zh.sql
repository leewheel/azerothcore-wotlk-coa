-- 试炼奖励物品名修正:97751 Trial Master's Trophy 此前被错翻为"猩红分立者绑腿"(错位)
-- By leewheel 20261031
UPDATE `item_template_locale` SET `Name` = '试炼大师的奖杯'
WHERE `ID` = 97751 AND `locale` = 'zhCN';
