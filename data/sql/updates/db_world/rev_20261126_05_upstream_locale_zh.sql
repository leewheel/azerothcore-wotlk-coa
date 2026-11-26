-- 补齐上游 rev_20262511_03_WF_NPC_Sepulcher.sql 新建物件的简体中文名
-- 该脚本用模板 90389 复制出 501007（Darrow Silverband），只写了英文原名，
-- 没有 gameobject_template_locale 的 zhCN 行，中文客户端会显示英文。
-- 1344800（Moonbathed Necklace）库里已有 zhCN「月浴项链」，无需再补。
-- By leewheel 2026年11月26日
INSERT INTO `gameobject_template_locale` (`entry`, `locale`, `name`, `castBarCaption`, `VerifiedBuild`) VALUES
(501007, 'zhCN', '达罗·银环', NULL, NULL)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);
