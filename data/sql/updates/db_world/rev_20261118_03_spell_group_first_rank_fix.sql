-- 2026.11.18 修正上游 rev_20261117_20_guardian_honor_exclusive 的 spell_group 误配
--
-- 上游把 Guardian Honor 的 2~6 级（301228~301232，首级 300856）连同 Greater Honor（680280）
-- 一起塞进 spell_group 2112508 做互斥。AzerothCore 加载 spell_group 时要求组内每个 spell 必须是
-- 自己 rank 链的首级；这 5 个是 300856 的后续等级，于是服务端启动刷 5 条
-- "Spell X listed in `spell_group` is not first rank of spell." 告警。
--
-- 修法：只删掉这 5 条误入行，保留首级 300856 与 680280，互斥功能不变
-- （后续等级由 spell_ranks 的 rank 链自动归属首级，无需在组内逐个列出）。
-- 全表预扫确认这 5 条是唯一误入项。
-- By leewheel 20261118

DELETE FROM `spell_group` WHERE `id` = 2112508
    AND `spell_id` IN (301228, 301229, 301230, 301231, 301232);
