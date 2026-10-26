-- By leewheel 2026年10月26日
-- 修复 creature_template 杂项校验错误（每条与核心报错一一对应）：
-- 1) 1131897：带 UNIT_NPC_FLAG_SPELLCLICK(16777216) 但 spellclick 表无数据，核心已强制移除，DB 同步清除。
-- 2) 9920211：作为 175038 的任务给予者但缺 QUESTGIVER(2) 位，补上。
-- 3) 162943：有 gossip_menu 85160 但缺 GOSSIP(1) 位，补上。
-- 4) 164544：KillCredit1=1005014 生物不存在，置 0。
-- 5) 1102630/1105913：difficulty_entry_1/2 与 2630/5913 重复引用 102630/105913（"already listed
--    as difficulty_entry"），清 1102630/1105913 侧的引用，保留 2630/5913 原映射。
-- 备份：Tempfiles/db_backup_20261026/backup_round2a_20261026.txt (===creature_misc===)

UPDATE creature_template SET npcflag = npcflag & ~16777216 WHERE entry = 1131897;

UPDATE creature_template SET npcflag = npcflag | 2 WHERE entry = 9920211;

UPDATE creature_template SET npcflag = npcflag | 1 WHERE entry = 162943;

UPDATE creature_template SET KillCredit1 = 0 WHERE entry = 164544;

UPDATE creature_template SET difficulty_entry_1 = 0, difficulty_entry_2 = 0 WHERE entry IN (1102630, 1105913);
