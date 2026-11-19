-- 2026.11.20 光辉信徒 161786（光辉镇，寒脊山谷，议题 #11424）显示为绿块：
-- 客户端缺少 32630（CreatureDisplayExtra-21646）、47042（-29140）、47043（-29157）这几个烘焙过的 NPC 贴图。
-- 每个都替换为议题 #6747 已批准的替身：同种族、同性别、同装束且在客户端里有烘焙贴图的模型——
-- 25525 矮人男潜水头盔、6981 侏儒男、6982 侏儒女太空头盔。Idx 1 保留能正常渲染的 14656。
-- 上游 #12825。// By leewheel 20261120
DELETE FROM `creature_template_model` WHERE `CreatureID` = 161786 AND `Idx` IN (0, 2, 3);
INSERT INTO `creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`) VALUES
(161786, 0, 25525, 1, 1),
(161786, 2, 6981, 1, 1),
(161786, 3, 6982, 1, 1);
