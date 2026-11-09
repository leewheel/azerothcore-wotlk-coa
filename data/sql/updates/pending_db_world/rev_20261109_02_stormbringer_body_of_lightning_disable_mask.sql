-- By leewheel 2026年11月9日
-- spell_proc 里 500041 Body of Lightning 的 DisableEffectsMask = 6（EFFECT_1 | EFFECT_2），
-- 但这条法术的 Effect[0] / Effect[1] 才是 APPLY_AURA（光环 42 / 21），Effect[2] 是 137 ENERGIZE_PCT。
-- 核心只允许把 aura 效果放进这个掩码，启动时会报
-- "The `spell_proc` table entry for spellId 500041 has DisableEffectsMask with effect 2, but effect 2 is not an aura effect"。
-- 该掩码只在遍历光环效果的代码路径里生效（SpellAuras.cpp 的 proc 判定），非 aura 位本来就不起作用，
-- 因此清成 2（只禁用 EFFECT_1）行为不变，警告消失。
-- End By leewheel

UPDATE `spell_proc` SET `DisableEffectsMask` = 2 WHERE `SpellId` = 500041;
