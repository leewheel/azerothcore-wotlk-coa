-- By leewheel 20261113
-- npc_vendor 里的负数 item 清理 + Cogsley 货单补齐
--
-- 背景：
-- npc_vendor.item 在本库是带符号 int（其它战利品表都是 int unsigned），
-- 有 4 行把它写成了负数，全都是「引用另一个商人的货单」这种 npc_vendor 并不支持的做法：
--   data/sql/base/db_world/npc_vendor.sql: 34043 / 34080 / 34081 -> -34040
--   modules/mod-manastorm-endless/.../11_manastorm_hub_vendors.sql: 80919 -> -179539
--     （该行注释原文：Reference Cogsworth's full vendor list）
-- 负数 item 在服务端加载商人时找不到物品模板，直接跳过，所以这几个商人本来就什么都不卖。
--
-- 为什么要清：
-- CoA 拍卖机器人（AiPlayerbot.CoaEconomy.AHBot.Enable = 1）会用下面这条查询收集可上架物品：
--   SELECT Item FROM creature_loot_template ... UNION SELECT item FROM npc_vendor
-- UNION 取第一列的列名 Item，而负数被带进结果集，服务端按 unsigned 读取时打 LOG_FATAL，
-- 写进 Errors.log 两条：
--   Incorrect value '-34040' for type 'unsigned int'
--   Incorrect value '-179539' for type 'unsigned int'
-- 门禁要求 Errors.log 必须为 0 字节，所以这 4 行必须清掉。

DELETE FROM `npc_vendor` WHERE `item` < 0;

-- Cogsley(80919) 与 Cogsworth(179539) 是同一个 Manastorm Gadget Vendor 的两个实例
-- （同 display 100722、同子名 Manastorm Gadget Vendor）。
-- 原来那行负数就是想让它卖 Cogsworth 的货，这里改为把 Cogsworth 的货单原样复制过来，
-- 先把 80919 的旧行删掉再插入，保证本补丁可以重复执行。
DELETE FROM `npc_vendor` WHERE `entry` = 80919;

INSERT INTO `npc_vendor`
(
    `entry`,
    `slot`,
    `item`,
    `maxcount`,
    `incrtime`,
    `ExtendedCost`,
    `VerifiedBuild`
)
SELECT
    80919,
    `slot`,
    `item`,
    `maxcount`,
    `incrtime`,
    `ExtendedCost`,
    `VerifiedBuild`
FROM `npc_vendor`
WHERE `entry` = 179539;
