-- COA 物品名中文化（收尾批次）//By leewheel 2026年10月30日
-- 剩余 16187 条为开发占位（PH/GM/美术资源件/旧标记），玩家不可见，保留英文
-- 本批仅落库已定译的 17 条

SET NAMES 'utf8mb4';

INSERT INTO `item_template_locale` (`ID`,`locale`,`Name`,`Description`) VALUES
(1977345, 'zhCN', '（旧）天界观察者支持者礼包', NULL),
(900003, 'zhCN', 'GM制服', NULL),
(900004, 'zhCN', 'GM制服', NULL),
(900005, 'zhCN', 'GM制服', NULL),
(900006, 'zhCN', 'GM制服', NULL),
(900007, 'zhCN', 'GM制服', NULL),
(900009, 'zhCN', 'GM制服', NULL),
(900023, 'zhCN', '无尽业火太刀', NULL),
(53534, 'zhCN', '忍者之剑', NULL),
(355128, 'zhCN', '驯兽大师的哨角：老斯卡特斯', NULL),
(6011328, 'zhCN', '血铸古神的指引', NULL),
(6311328, 'zhCN', '血铸古神的指引', NULL),
(6072860, 'zhCN', '血铸上古者的颚骨', NULL),
(6067071, 'zhCN', '血铸古殇法杖', NULL),
(5556074, 'zhCN', '古神教派之锤（背鞘）', NULL),
(525442, 'zhCN', '受支配的古神套装宝箱', NULL),
(2067113, 'zhCN', '古神之拥腰带', NULL)
ON DUPLICATE KEY UPDATE `Name` = VALUES(`Name`);

-- 结束：17 条
