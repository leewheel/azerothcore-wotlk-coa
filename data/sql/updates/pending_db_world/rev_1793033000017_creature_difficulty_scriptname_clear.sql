-- 清空 22 个难度条目（DifficultyEntry）的 ScriptName
-- 核心 ObjectMgr 校验：难度条目填 ScriptName 会导致难度映射被跳过（continue），
-- 且运行时本就只用难度0条目的 ScriptName，清空无玩法影响、并使难度映射生效
-- 原值备份 Tempfiles/db_backup_20261026/backup_difficulty_scriptname.txt
-- By leewheel 2026年10月26日
UPDATE creature_template SET ScriptName='' WHERE entry IN (110184,192028,192027,192026,180643,180642,112268,112264,112259,112143,112118,112099,112098,112057,112056,112018,111988,111982,111672,111671,111662,111502) AND ScriptName!='';
