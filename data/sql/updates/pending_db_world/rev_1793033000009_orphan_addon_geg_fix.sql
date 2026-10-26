-- By leewheel 2026年10月26日 孤儿引用清理
-- 1) creature_addon 指向不存在 creature GUID（17 条）——运行时本就不加载，删除
-- 2) game_event_gameobject 指向不存在 gameobject GUID（21 条）——运行时忽略，删除
-- 备份：Tempfiles/db_backup_20261026/backup_creature_addon_orphans_20261026.txt / backup_geg_orphans_20261026.txt
DELETE FROM `creature_addon` WHERE `guid` IN (52150,54237,9013000,9013002,9013004,9013008,9013012,9013015,9013017,9013018,9013019,9013020,9013021,9013022,9013027,9013029,9013030);
DELETE FROM `game_event_gameobject` WHERE `guid` IN (151830,151831,151832,151833,151857,151858,151859,151874,151875,151876,151877,151878,151879,151880,151881,151882,151883,151884,151885,151886,151887);
