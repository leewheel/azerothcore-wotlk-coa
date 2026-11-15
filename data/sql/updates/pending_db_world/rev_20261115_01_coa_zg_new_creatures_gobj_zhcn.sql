-- By leewheel 20261115
-- 上游 57 提交新增的三个可见对象补简体中文名：
--   14914 系（含英雄/史诗/飞升副本 114914/214914/314914） Zul'Gurub 耶克里克的疯狂蝙蝠骑士
--   14915 系（含英雄/史诗/飞升副本 114915/214915/314915） Zul'Gurub 玛尔里的蜘蛛卵
--   978099 雪墓（Snowgrave）竞技场天花板悬挂的冰锥（gameobject，被 Massive Stomp 击落）
-- 名称来源：对应上游 SQL 的 creature_template.name / gameobject_template.name。
-- 本文件必须在 rev_20261112_92_zul_gurub_jeklik_crazed_bat_riders.sql、
-- rev_20261114_41_zul_gurub_marli_spider_egg_creatures.sql、
-- rev_20261114_10_coa_snowgrave_stalactites.sql 之后执行（文件名时间戳已晚于三者）。

INSERT INTO `creature_template_locale` (`entry`, `locale`, `Name`, `Title`, `VerifiedBuild`) VALUES
(14914,  'zhCN', '疯狂的蝙蝠骑士', '', 12340),
(114914, 'zhCN', '疯狂的蝙蝠骑士', '', 12340),
(214914, 'zhCN', '疯狂的蝙蝠骑士', '', 12340),
(314914, 'zhCN', '疯狂的蝙蝠骑士', '', 12340),
(14915,  'zhCN', '蜘蛛卵', '', 12340),
(114915, 'zhCN', '蜘蛛卵', '', 12340),
(214915, 'zhCN', '蜘蛛卵', '', 12340),
(314915, 'zhCN', '蜘蛛卵', '', 12340)
ON DUPLICATE KEY UPDATE `Name` = VALUES(`Name`), `Title` = VALUES(`Title`);

INSERT INTO `gameobject_template_locale` (`entry`, `locale`, `name`, `castBarCaption`, `VerifiedBuild`) VALUES
(978099, 'zhCN', '悬挂的冰锥', '', 12340)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `castBarCaption` = VALUES(`castBarCaption`);
-- End By leewheel
