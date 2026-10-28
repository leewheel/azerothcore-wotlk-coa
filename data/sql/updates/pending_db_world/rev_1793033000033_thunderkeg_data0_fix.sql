-- #By leewheel 2026年10月28日
-- 门禁 r3 复验发现：rev_1793033000032 补回 GO 195002 Thunderkeg 模板后，加载校验报
-- "Gameobject (Entry: 195002 GoType: 22) have data0=0 but Spell (Entry 0) not exist."
-- （ObjectMgr.cpp GAMEOBJECT_TYPE_SPELLCASTER 分支 CheckGOSpellId 总是要求 data0 指向存在的法术，
--   上游 rev_20260930_93 的注释"schema default 0 is sufficient"只对 Spell::EffectTransmitted
--   运行期成立，不满足启动期 CheckGOSpellId 校验。）
-- 修法：data0 = 807849（Conjure Thunderkeg，即召唤本 GO 的法术；Spell.dbc 中唯一
-- EffectMiscValue 含 195002 的法术）。该 GO 由 TRANS_DOOR 召唤、无交互 flag，玩家无法
-- "使用"它，data0 仅用于通过加载校验，语义上也与 GO 来源一致。
UPDATE `gameobject_template` SET `Data0` = 807849 WHERE `entry` = 195002 AND `type` = 22;
