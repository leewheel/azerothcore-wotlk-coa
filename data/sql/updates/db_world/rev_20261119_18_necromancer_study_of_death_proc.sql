-- By leewheel 20261119
-- 玩家反馈 bug_137：死灵天赋「死亡研究」704721 的「仆从的冰霜/物理伤害使邪恶狂乱冷却缩短 0.5 秒」不生效。
--
-- 这一条是数据侧的兜底：核心 Aura::GetProcEffectMask 的第一关是
--   "only auras with spell proc entry can trigger proc"（SpellAuras.cpp）
-- 也就是法术必须在 spell_proc 里有条目，否则该光环一个 proc 都不会触发。
-- 死灵的事件光环 805011（生命之力）与仆从光环 805015（死灵仆从缩放应用器）
-- 全靠这两行才能收到「仆从造成伤害」的事件；缺行时整个仆从 proc 分支（含本条天赋、Pandemic 等）全部失效。
--
-- 参数与核心基线一致：Chance 100、无内置冷却、无充能，允许被触发法术继续 proc，
-- ProcFlags 1048575 覆盖近战/远程/法术/周期伤害的造成与承受位。
-- 幂等写法：已有行则只把参数对齐，不会重复插入（SpellId 是主键）。
INSERT INTO `spell_proc`
    (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`,
     `ProcFlags`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`,
     `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`)
VALUES
    (805011, 0, 0, 0, 0, 0, 1048575, 3, 2, 3, 2, 0, 0, 100, 0, 0),
    (805015, 0, 0, 0, 0, 0, 1048575, 3, 2, 3, 2, 0, 0, 100, 0, 0)
ON DUPLICATE KEY UPDATE
    `ProcFlags` = VALUES(`ProcFlags`),
    `SpellTypeMask` = VALUES(`SpellTypeMask`),
    `SpellPhaseMask` = VALUES(`SpellPhaseMask`),
    `HitMask` = VALUES(`HitMask`),
    `AttributesMask` = VALUES(`AttributesMask`),
    `DisableEffectsMask` = VALUES(`DisableEffectsMask`),
    `Chance` = VALUES(`Chance`),
    `Cooldown` = VALUES(`Cooldown`),
    `Charges` = VALUES(`Charges`);
-- End By leewheel
