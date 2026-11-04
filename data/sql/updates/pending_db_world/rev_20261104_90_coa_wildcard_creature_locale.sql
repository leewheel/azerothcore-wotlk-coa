-- 上游 2026-11-04 合并（Wildcard / WarcraftReborn 修复）新增或改名的生物补简体中文名。
-- 只补 zhCN；英文仍留在 creature_template.name，客户端按语言读这份表。
-- By leewheel 2026年11月04日
INSERT INTO `creature_template_locale` (`entry`, `locale`, `Name`, `VerifiedBuild`) VALUES
(379386, 'zhCN', '龙裔形态', 0),
(280576, 'zhCN', '烈焰龙卷', 0),
(80220,  'zhCN', '上古列王守护者', 0),
(280450, 'zhCN', '战争魔像', 0),
(280511, 'zhCN', '僵尸', 0),
(840095, 'zhCN', '虚空传送门', 0),
(840096, 'zhCN', '萨特', 0),
(840097, 'zhCN', '虚空恐魔', 0)
ON DUPLICATE KEY UPDATE `Name` = VALUES(`Name`), `VerifiedBuild` = VALUES(`VerifiedBuild`);
-- End By leewheel
