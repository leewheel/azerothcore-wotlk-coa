-- By leewheel 2026年10月26日
-- 修复：难度条目（difficulty_entry 引用行）不允许携带 ScriptName/AIName，
-- 核心 ObjectMgr 校验会报 "difficulty entry has ScriptName" 并 continue 跳过难度映射。
-- 运行时难度 1-3 生物统一走基础条目的脚本，故清空这 44 条难度条目的 ScriptName。
-- 备份：Tempfiles/db_backup_20261026/backup_round2a_20261026.txt (===difficulty44===)

UPDATE creature_template SET ScriptName = '' WHERE entry IN (
210184,211502,211662,211671,211672,211982,211988,212018,212056,212057,212098,212099,212118,212143,212259,212264,212268,280642,280643,292026,292027,292028,
310184,311502,311662,311671,311672,311982,311988,312018,312056,312057,312098,312099,312118,312143,312259,312264,312268,380642,380643,392026,392027,392028
) AND ScriptName != '';
