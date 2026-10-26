-- By leewheel 2026年10月26日
-- 修复："Wrong skill id X in `playercreateinfo_skills` table, ignoring."
-- 14 个技能 ID 不在 SkillLine.dbc（3.3.5 无效技能行），删除。
-- 备份：Tempfiles/db_backup_20261026/backup_round2b_20261026.txt (===pc_skills===)

DELETE FROM playercreateinfo_skills WHERE skill IN (
163,237,253,256,257,267,355,374,375,573,574,593,594,613
);
