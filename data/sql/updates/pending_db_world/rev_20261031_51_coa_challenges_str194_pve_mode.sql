-- 挑战模块字符串 194：Your active challenge requires PvE mode.
-- 修复上游 C2672（NotifyPlayer 传字面串而非字符串 ID），配套 STR_RULE_PVE_MODE_REQUIRED = 194
-- 英文进 module_string 主表作回落，译文进 module_string_locale zhCN //By leewheel 2026年10月30日
DELETE FROM `module_string` WHERE `module`='mod-coa-challenges' AND `id`=194;
INSERT INTO `module_string` (`module`, `id`, `string`) VALUES
('mod-coa-challenges', 194, 'Your active challenge requires PvE mode.');
DELETE FROM `module_string_locale` WHERE `module`='mod-coa-challenges' AND `id`=194 AND `locale`='zhCN';
INSERT INTO `module_string_locale` (`module`, `id`, `locale`, `string`) VALUES
('mod-coa-challenges', 194, 'zhCN', '你当前进行中的挑战需要 PVE 模式。');
