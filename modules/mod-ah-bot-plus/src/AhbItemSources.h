// mod-ah-bot-plus 的 CoA 物品来源查询。
// 本核心没有为拍卖行机器人准备 WORLD_SEL_AUCTION_BOT_* 预编译语句，
// 因此把两条查询放在模块内直接执行，避免改动核心数据库头文件。
// SQL 与原版 mod-ah-bot-plus（Corfirean/azerothcore-wotlk-coa@coa-bots）一致。
// By leewheel 2026年11月04日
#ifndef _AHB_ITEM_SOURCES_H_
#define _AHB_ITEM_SOURCES_H_

namespace AhbItemSources
{
// 所有有来源的掉落物品（掉落表 + 商人）；负数是旧式引用行，不是真实物品，外层统一过滤掉。
inline char const* const ItemSources =
    "SELECT Item FROM (SELECT Item FROM creature_loot_template WHERE Reference = 0 AND QuestRequired = 0 "
    "UNION SELECT Item FROM gameobject_loot_template WHERE Reference = 0 AND QuestRequired = 0 "
    "UNION SELECT Item FROM reference_loot_template WHERE Reference = 0 AND QuestRequired = 0 "
    "UNION SELECT Item FROM fishing_loot_template WHERE Reference = 0 AND QuestRequired = 0 "
    "UNION SELECT Item FROM skinning_loot_template WHERE Reference = 0 AND QuestRequired = 0 "
    "UNION SELECT Item FROM item_loot_template WHERE Reference = 0 AND QuestRequired = 0 "
    "UNION SELECT Item FROM disenchant_loot_template WHERE Reference = 0 AND QuestRequired = 0 "
    "UNION SELECT Item FROM prospecting_loot_template WHERE Reference = 0 AND QuestRequired = 0 "
    "UNION SELECT Item FROM milling_loot_template WHERE Reference = 0 AND QuestRequired = 0 "
    "UNION SELECT Item FROM pickpocketing_loot_template WHERE Reference = 0 AND QuestRequired = 0 "
    "UNION SELECT item FROM npc_vendor) AS s WHERE Item > 0";

// 原版世界（低等级地图、60 级物品、商人、矿点、钓鱼、分解/选矿/研磨）里有来源的物品，
// 用来把后续资料片的货物挡在拍卖行之外（例如需要 58 级的魔纹布）。
inline char const* const VanillaSources =
    "SELECT Item FROM (SELECT l.Item FROM creature_loot_template l JOIN (SELECT ct.lootid, ct.skinloot, ct.pickpocketloot FROM "
    "creature_template ct WHERE (ct.maxlevel <= 63 AND EXISTS (SELECT 1 FROM creature c WHERE c.id = ct.entry"
    " AND c.map IN "
    "(0,1,33,34,36,43,47,48,70,90,109,129,189,209,229,230,289,309,329,349,369,389,409,429,469,509,531))) OR "
    "(ct.maxlevel <= 25 AND EXISTS (SELECT 1 FROM creature c WHERE c.id = ct.entry AND c.map = 530))) v ON "
    "l.Entry = v.lootid WHERE l.Reference = 0 UNION SELECT r.Item FROM creature_loot_template l JOIN (SELECT "
    "ct.lootid, ct.skinloot, ct.pickpocketloot FROM creature_template ct WHERE (ct.maxlevel <= 63 AND EXISTS "
    "(SELECT 1 FROM creature c WHERE c.id = ct.entry AND c.map IN "
    "(0,1,33,34,36,43,47,48,70,90,109,129,189,209,229,230,289,309,329,349,369,389,409,429,469,509,531))) OR "
    "(ct.maxlevel <= 25 AND EXISTS (SELECT 1 FROM creature c WHERE c.id = ct.entry AND c.map = 530))) v ON "
    "l.Entry = v.lootid JOIN reference_loot_template r ON r.Entry = l.Reference WHERE l.Reference > 0 AND "
    "r.Reference = 0 UNION SELECT r2.Item FROM creature_loot_template l JOIN (SELECT ct.lootid, ct.skinloot, "
    "ct.pickpocketloot FROM creature_template ct WHERE (ct.maxlevel <= 63 AND EXISTS (SELECT 1 FROM creature c"
    " WHERE c.id = ct.entry AND c.map IN "
    "(0,1,33,34,36,43,47,48,70,90,109,129,189,209,229,230,289,309,329,349,369,389,409,429,469,509,531))) OR "
    "(ct.maxlevel <= 25 AND EXISTS (SELECT 1 FROM creature c WHERE c.id = ct.entry AND c.map = 530))) v ON "
    "l.Entry = v.lootid JOIN reference_loot_template r ON r.Entry = l.Reference JOIN reference_loot_template "
    "r2 ON r2.Entry = r.Reference WHERE l.Reference > 0 AND r.Reference > 0 UNION SELECT l.Item FROM "
    "skinning_loot_template l JOIN (SELECT ct.lootid, ct.skinloot, ct.pickpocketloot FROM creature_template ct"
    " WHERE (ct.maxlevel <= 63 AND EXISTS (SELECT 1 FROM creature c WHERE c.id = ct.entry AND c.map IN "
    "(0,1,33,34,36,43,47,48,70,90,109,129,189,209,229,230,289,309,329,349,369,389,409,429,469,509,531))) OR "
    "(ct.maxlevel <= 25 AND EXISTS (SELECT 1 FROM creature c WHERE c.id = ct.entry AND c.map = 530))) v ON "
    "l.Entry = v.skinloot UNION SELECT l.Item FROM pickpocketing_loot_template l JOIN (SELECT ct.lootid, "
    "ct.skinloot, ct.pickpocketloot FROM creature_template ct WHERE (ct.maxlevel <= 63 AND EXISTS (SELECT 1 "
    "FROM creature c WHERE c.id = ct.entry AND c.map IN "
    "(0,1,33,34,36,43,47,48,70,90,109,129,189,209,229,230,289,309,329,349,369,389,409,429,469,509,531))) OR "
    "(ct.maxlevel <= 25 AND EXISTS (SELECT 1 FROM creature c WHERE c.id = ct.entry AND c.map = 530))) v ON "
    "l.Entry = v.pickpocketloot UNION SELECT nv.item FROM npc_vendor nv WHERE EXISTS (SELECT 1 FROM creature c"
    " WHERE c.id = nv.entry AND c.map IN "
    "(0,1,33,34,36,43,47,48,70,90,109,129,189,209,229,230,289,309,329,349,369,389,409,429,469,509,531)) UNION "
    "SELECT l.Item FROM gameobject_loot_template l WHERE l.Reference = 0 AND l.Entry IN (SELECT gt.data1 FROM "
    "gameobject_template gt WHERE gt.type IN (3, 25) AND EXISTS (SELECT 1 FROM gameobject g WHERE g.id = "
    "gt.entry AND g.map IN "
    "(0,1,33,34,36,43,47,48,70,90,109,129,189,209,229,230,289,309,329,349,369,389,409,429,469,509,531))) UNION"
    " SELECT r.Item FROM gameobject_loot_template l JOIN reference_loot_template r ON r.Entry = l.Reference "
    "WHERE l.Reference > 0 AND l.Entry IN (SELECT gt.data1 FROM gameobject_template gt WHERE gt.type IN (3, "
    "25) AND EXISTS (SELECT 1 FROM gameobject g WHERE g.id = gt.entry AND g.map IN "
    "(0,1,33,34,36,43,47,48,70,90,109,129,189,209,229,230,289,309,329,349,369,389,409,429,469,509,531))) UNION"
    " SELECT Item FROM fishing_loot_template WHERE Entry < 3430 AND Entry NOT IN (65, 66, 67, 210, 394, 495, "
    "2817) UNION SELECT l.Item FROM prospecting_loot_template l JOIN item_template i ON i.entry = l.Entry "
    "WHERE i.ItemLevel <= 60 AND i.RequiredLevel < 58 UNION SELECT l.Item FROM milling_loot_template l JOIN "
    "item_template i ON i.entry = l.Entry WHERE i.ItemLevel <= 60 AND i.RequiredLevel < 58 UNION SELECT l.Item"
    " FROM disenchant_loot_template l JOIN item_template i ON i.DisenchantID = l.Entry WHERE i.ItemLevel <= 65"
    " AND i.RequiredLevel <= 60) AS s WHERE Item > 0";
} // namespace AhbItemSources

#endif
// End By leewheel
