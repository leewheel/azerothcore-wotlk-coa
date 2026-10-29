-- mod-ethereal-bazaar 玩家可见文本接入 module_string（空缓存提示 / 集合缓存补发邮件主题与正文）
-- 对应 C++：EtherealBazaarSetCaches.cpp STR_CACHE_EMPTY=1 / STR_MAIL_SUBJECT=2 / STR_MAIL_BODY=3
-- #By leewheel 2026年10月29日
INSERT IGNORE INTO `module_string` (`module`,`id`,`string`) VALUES
('mod-ethereal-bazaar',1,'This cache is empty. Tell an administrator.'),
('mod-ethereal-bazaar',2,'Set cache'),
('mod-ethereal-bazaar',3,'Your bags were full, so the rest of your set was sent by mail.');
INSERT IGNORE INTO `module_string_locale` (`module`,`id`,`locale`,`string`) VALUES
('mod-ethereal-bazaar',1,'zhCN','这个缓存箱是空的。请告知管理员。'),
('mod-ethereal-bazaar',2,'zhCN','套装缓存箱'),
('mod-ethereal-bazaar',3,'zhCN','你的背包已满，套装的其余部分已通过邮件寄给你。');
