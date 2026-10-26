-- By leewheel 2026年10月26日
-- Errors.log 治理第三轮：清除门禁 10 分钟跑出的非豁免错误（spelldifficulty_dbc 豁免除外）
-- 备份：Tempfiles/db_backup_20261026/backup_round3a~h_20261026.txt

-- 1) spell_custom_attr 510176 声明 SPELL_ATTR0_CU_POSITIVE_EFF2(0x08000000) 但该法术无 EFFECT_2：清掉该位
UPDATE spell_custom_attr SET attributes = attributes & ~0x08000000 WHERE spell_id = 510176;

-- 2) spell_proc -12966 定义了 SpellPhaseMask 但 ProcFlags 不含 SPELL_PHASE 类标志，该值不会生效：置 0
UPDATE spell_proc SET SpellPhaseMask = 0 WHERE SpellId = -12966;

-- 3) item 262673 属 special learning format（spellid_1=55884）但 spelltrigger_2 仍为 LEARN_SPELL_ID 而 spellid_2 为空：整组清零
UPDATE item_template SET spellid_1 = 0, spelltrigger_1 = 0, spelltrigger_2 = 0 WHERE entry = 262673;

-- 4) 难度条目 family 与基础条目不一致：同步为与基础条目相同
UPDATE creature_template SET family = 404 WHERE entry IN (210184, 310184);
UPDATE creature_template SET family = 305 WHERE entry IN (212057, 312057);
UPDATE creature_template SET family = 303 WHERE entry IN (212056, 312056);

-- 5) 任务指向不存在的区域/任务类别：置 0
UPDATE quest_template SET QuestSortID = 0 WHERE ID = 14224;
UPDATE quest_template SET QuestSortID = 0 WHERE ID = 200024;

-- 6) spell_area 引用了不存在的法术 45374（光环 45373 的错误伴生行）：删除
DELETE FROM spell_area WHERE spell = 45374;

-- 7) 生物 9300252/9300254 的 lootid 指向自身但 creature_loot_template 无对应 Entry：补占位行（参照 rev_00013 模式）
INSERT IGNORE INTO creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment)
VALUES (9300252, 33470, 0, 0.000001, 0, 1, 0, 1, 1, 'By leewheel 20261026 placeholder for empty creature loot'),
       (9300254, 33470, 0, 0.000001, 0, 1, 0, 1, 1, 'By leewheel 20261026 placeholder for empty creature loot');

-- 8) spell_script_names 治理
-- 8a) COA 改过 Spell.dbc 后 hook 绑定与 DBC 失配、handler 本就不会执行，且该脚本名已无任何有效挂载：
--     删除挂载行（C++ 侧同步注销注册，否则会新增 "not assigned in the database" 报错）
DELETE FROM spell_script_names WHERE ScriptName = 'aura_class_call_wild_magic' AND spell_id = 23410;
DELETE FROM spell_script_names WHERE ScriptName = 'aura_class_call_siphon_blessing' AND spell_id = 23418;
DELETE FROM spell_script_names WHERE ScriptName = 'aura_hero_hunter_entrapment';
DELETE FROM spell_script_names WHERE ScriptName = 'spell_allergies' AND spell_id = 31427;
DELETE FROM spell_script_names WHERE ScriptName = 'spell_arcane_chains_character_force_cast';
DELETE FROM spell_script_names WHERE ScriptName = 'spell_dk_killing_machine';
DELETE FROM spell_script_names WHERE ScriptName = 'spell_drakkari_colossus_emerge';
DELETE FROM spell_script_names WHERE ScriptName = 'spell_dru_glyph_of_starfire_dummy';
DELETE FROM spell_script_names WHERE ScriptName = 'spell_dru_t4_2p_bonus';
DELETE FROM spell_script_names WHERE ScriptName = 'spell_four_horsemen_mark_aura';
DELETE FROM spell_script_names WHERE ScriptName = 'spell_item_pet_healing';
DELETE FROM spell_script_names WHERE ScriptName = 'spell_item_sunwell_exalted_tank_neck';
DELETE FROM spell_script_names WHERE ScriptName = 'spell_mage_combustion_proc' AND spell_id = 28682;
DELETE FROM spell_script_names WHERE ScriptName = 'spell_mark_of_the_faceless_drainhealth';
DELETE FROM spell_script_names WHERE ScriptName = 'spell_q9847_a_spirit_ally';
DELETE FROM spell_script_names WHERE ScriptName = 'spell_rancid_spore_cloud';
DELETE FROM spell_script_names WHERE ScriptName = 'spell_rog_turn_the_tables_proc';
DELETE FROM spell_script_names WHERE ScriptName = 'spell_sha_item_lightning_shield_trigger';
DELETE FROM spell_script_names WHERE ScriptName = 'spell_tsh_shadow_bolt';
DELETE FROM spell_script_names WHERE ScriptName = 'spell_warr_glyph_of_sunder_armor';
DELETE FROM spell_script_names WHERE ScriptName = 'spell_web_wrap_damage';
DELETE FROM spell_script_names WHERE ScriptName = 'spell_soul_deflection';
DELETE FROM spell_script_names WHERE ScriptName = 'spell_rog_master_of_subtlety';
DELETE FROM spell_script_names WHERE ScriptName = 'spell_ascension_ranger_rusty_shiv';
-- 8b) 同一脚本仍有其他有效挂载/其他 hook 有效，仅删除已失配的挂载行（注册保留）
DELETE FROM spell_script_names WHERE ScriptName = 'spell_gen_moss_covered_feet' AND spell_id = 6870;
DELETE FROM spell_script_names WHERE ScriptName = 'spell_item_with_mount_speed' AND spell_id = 48776;
DELETE FROM spell_script_names WHERE ScriptName = 'spell_mage_imp_mana_gems' AND spell_id = 37447;
DELETE FROM spell_script_names WHERE ScriptName = 'spell_mage_deep_freeze_immunity_state' AND spell_id = 71761;
DELETE FROM spell_script_names WHERE ScriptName = 'spell_pilgrims_bounty_food' AND spell_id IN (65418, 65419, 65420, 65421, 65422, 66041);
DELETE FROM spell_script_names WHERE ScriptName = 'spell_gen_select_target_count_7_1' AND spell_id = 45680;
DELETE FROM spell_script_names WHERE ScriptName = 'spell_sha_frozen_power' AND spell_id = -63373;
DELETE FROM spell_script_names WHERE ScriptName = 'spell_sha_nature_guardian';
DELETE FROM spell_script_names WHERE ScriptName = 'spell_pal_seal_of_righteousness' AND spell_id = 20154;
DELETE FROM spell_script_names WHERE ScriptName = 'spell_pal_holy_shock' AND spell_id = -1120473;
