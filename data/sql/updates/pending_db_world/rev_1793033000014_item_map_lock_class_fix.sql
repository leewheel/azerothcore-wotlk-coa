-- 修复 item_template 悬空 Map/LockID 引用 与 Class 值不一致（共 35 条）
-- Map=0/LockID=0 语义为无限制/无锁；Class 按 Item.dbc 权威值回写
-- 原值备份 Tempfiles/db_backup_20261026/backup_item_maplockclass_rows.txt
-- By leewheel 2026年10月26日
UPDATE item_template SET Map=0 WHERE entry=79261 AND Map=999;
UPDATE item_template SET Map=0 WHERE entry=91906 AND Map=1104;
UPDATE item_template SET Map=0 WHERE entry=91971 AND Map=1104;
UPDATE item_template SET Map=0 WHERE entry=92035 AND Map=1104;
UPDATE item_template SET Map=0 WHERE entry=92061 AND Map=1104;
UPDATE item_template SET Map=0 WHERE entry=92444 AND Map=1104;
UPDATE item_template SET Map=0 WHERE entry=92470 AND Map=1104;
UPDATE item_template SET Map=0 WHERE entry=92472 AND Map=1104;
UPDATE item_template SET Map=0 WHERE entry=92538 AND Map=1104;
UPDATE item_template SET Map=0 WHERE entry=92556 AND Map=1112;
UPDATE item_template SET Map=0 WHERE entry=92739 AND Map=1104;
UPDATE item_template SET Map=0 WHERE entry=92743 AND Map=1104;
UPDATE item_template SET Map=0 WHERE entry=92745 AND Map=1104;
UPDATE item_template SET Map=0 WHERE entry=92750 AND Map=1104;
UPDATE item_template SET Map=0 WHERE entry=92751 AND Map=1104;
UPDATE item_template SET Map=0 WHERE entry=93742 AND Map=1030;
UPDATE item_template SET LockID=0 WHERE entry=63349 AND LockID=1946;
UPDATE item_template SET LockID=0 WHERE entry=68729 AND LockID=1948;
UPDATE item_template SET LockID=0 WHERE entry=88165 AND LockID=2048;
UPDATE item_template SET LockID=0 WHERE entry=88567 AND LockID=2048;
UPDATE item_template SET LockID=0 WHERE entry=810000 AND LockID=1;
UPDATE item_template SET LockID=0 WHERE entry=1007902 AND LockID=1;
UPDATE item_template SET LockID=0 WHERE entry=1014785 AND LockID=1;
UPDATE item_template SET LockID=0 WHERE entry=1021449 AND LockID=1;
UPDATE item_template SET LockID=0 WHERE entry=1028014 AND LockID=1;
UPDATE item_template SET LockID=0 WHERE entry=1034578 AND LockID=1;
UPDATE item_template SET LockID=0 WHERE entry=1041141 AND LockID=1;
UPDATE item_template SET LockID=0 WHERE entry=1047704 AND LockID=1;
UPDATE item_template SET LockID=0 WHERE entry=1054267 AND LockID=1;
UPDATE item_template SET LockID=0 WHERE entry=1060830 AND LockID=1;
UPDATE item_template SET LockID=0 WHERE entry=1067393 AND LockID=1;
UPDATE item_template SET Class=17 WHERE entry=82800 AND Class=15;
UPDATE item_template SET Class=18 WHERE entry=122270 AND Class=15;
UPDATE item_template SET Class=18 WHERE entry=122284 AND Class=15;
UPDATE item_template SET Class=17 WHERE entry=1804703 AND Class=15;
