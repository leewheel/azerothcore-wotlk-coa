-- World DB data errors that logged on every worldserver startup (Errors.log):
--   2 x "Spell N (rank 2) listed in `spell_ranks` for chain C does not exist!"
--   6 x "Table `spell_custom_attr` has attribute ... for spell N with no EFFECT_N"
--
-- The spells referenced below exist in neither Spell.dbc nor the spell_dbc
-- table (checked with apps/coa-dbc/coa-dbc-viewer), so the rows are dangling.
-- The spell_custom_attr masks are reduced to exactly the bits the server keeps
-- after its own load-time validation, which makes that strip permanent instead
-- of repeating the same errors on every boot. No applied attribute changes.

DELETE FROM `spell_ranks` WHERE `spell_id` IN (5599, 11719);

UPDATE `spell_custom_attr` SET `attributes` = 0         WHERE `spell_id` = 28282;   -- drop POSITIVE_EFF1 (0x04000000), no EFFECT_1
UPDATE `spell_custom_attr` SET `attributes` = 8192      WHERE `spell_id` = 29214;   -- drop NEGATIVE_EFF0 (0x1000), keep EFF1
UPDATE `spell_custom_attr` SET `attributes` = 12288     WHERE `spell_id` = 34709;   -- drop NEGATIVE_EFF2 (0x4000), keep EFF0|EFF1
UPDATE `spell_custom_attr` SET `attributes` = 100663296 WHERE `spell_id` = 541493;  -- drop POSITIVE_EFF2 (0x08000000), keep EFF0|EFF1
UPDATE `spell_custom_attr` SET `attributes` = 33554432  WHERE `spell_id` = 706241;  -- drop POSITIVE_EFF1|EFF2, keep EFF0
