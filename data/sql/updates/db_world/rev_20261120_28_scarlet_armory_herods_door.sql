-- By leewheel 20261120
-- #13002 血色修道院军械库：赫洛德的房门（物件 101854，guid 32250）改为可点击并保持开启
-- 原来点击后会自动关上，现在与实战一致：点一次即开，之后不再自动关闭
-- End By leewheel
UPDATE `gameobject` SET `state` = 1 WHERE `guid` = 32250 AND `id` = 101854;
