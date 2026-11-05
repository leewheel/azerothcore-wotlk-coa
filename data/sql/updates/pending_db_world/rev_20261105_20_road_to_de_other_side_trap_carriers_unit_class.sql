-- 毒液陷阱搬运者（Venom Trap Carrier）三档生物建表时没给 unit_class，核心启动会报
-- Creature (Entry: 993700x) has invalid unit_class (0) in creature_template，这里统一补成战士（1）。
-- By leewheel 2026年11月5日
UPDATE `creature_template` SET `unit_class` = 1 WHERE `entry` IN (9937001, 9937002, 9937003);
-- End By leewheel
