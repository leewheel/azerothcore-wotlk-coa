-- 血饮者的原始装束（空缓存物品 213347）不再在幻市出售：
-- 捐赠点、赛季点、集市代币三种价格全部清零，并从幻市货架池与套装缓存里移除。
-- 上游 #12902。本脚本无玩家可见文本。
-- By leewheel 20261120
-- End By leewheel

UPDATE `coa_client_vanity_collection`
SET `DonationPointCost` = 0, `SeasonalPointCost` = 0, `BazaarTokenCost` = 0
WHERE `ItemID` = 213347;

DELETE FROM `ethereal_bazaar_pool` WHERE `item` = 213347;

DELETE FROM `ethereal_bazaar_set_cache` WHERE `cache_item` = 213347 AND `member_item` BETWEEN 213348 AND 213355;
