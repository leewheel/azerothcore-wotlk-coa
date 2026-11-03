-- 门禁两条数据错误的根因修复。
-- 1) spell_custom_attr：法术 9930831 只有 EFFECT_0/EFFECT_1，属性里却带了 SPELL_ATTR0_CU_POSITIVE_EFF2(0x08000000)，
--    核心启动校验会报 "has attribute SPELL_ATTR0_CU_POSITIVE_EFF2 for spell 9930831 with no EFFECT_2"。
--    这里只清掉那一个无效位（POSITIVE_EFF0/EFF1 保留）。
-- 2) smart_scripts：生物 14908 的事件 7（Mogg - On Waypoint 29 Reached - Run Script）link 指向事件 8，
--    但该生物没有 id=8 的事件，核心会报 "Link Event 8 not found, skipped" 并跳过这条脚本。
--    这里把 link 归零，让该事件照常执行（不再等一个不存在的后继）。
-- By leewheel 2026年11月3日
UPDATE `spell_custom_attr` SET `attributes` = `attributes` & ~0x08000000 WHERE `spell_id` = 9930831;
UPDATE `smart_scripts` SET `link` = 0 WHERE `entryorguid` = 14908 AND `source_type` = 0 AND `id` = 7 AND `link` = 8;
-- End By leewheel
