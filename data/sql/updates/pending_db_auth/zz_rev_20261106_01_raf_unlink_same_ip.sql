-- By leewheel 2026年11月12日 幂等化改动（只动 generation 的触发条件，清理逻辑一行未改）：
-- 原脚本第 7-8 行是无条件 `generation = generation + 1`，启动器每次更新都会把包内 SQL 全量重导一遍，
-- 于是数据一点没变、代次号也照样往前推一格 —— 全库 CHECKSUM 比对永远对不上，也没法判断这一遍到底改了什么。
-- 改成：先把「同 IP 招募」的账号名单算出来，名单非空（= 这一遍真的要清理数据）才推代次；
-- 名单为空时一个字节都不动。代次号是给服务端做 RAF 缓存失效用的信号，值是几不影响功能，只要求"数据变才变"。
-- 顺序也相应调整：原来 generation 在算名单之前就推了，现在挪到 INSERT ... SELECT 之后，
-- 这样 EXISTS 判断的才是本轮的真实结果。清理语句（DELETE / UPDATE account）保持原顺序与原文，未做任何修改。
CREATE TEMPORARY TABLE `raf_same_ip_recruits` (
    `account_id` INT UNSIGNED NOT NULL PRIMARY KEY
) ENGINE=InnoDB;

START TRANSACTION;

INSERT IGNORE INTO `raf_link_lock` (`id`) VALUES (1);

INSERT IGNORE INTO `raf_same_ip_recruits` (`account_id`)
SELECT `recruit`.`id`
FROM `account` `recruit`
JOIN `account` `recruiter` ON `recruiter`.`id` = `recruit`.`recruiter`
WHERE `recruit`.`last_login` IS NOT NULL AND `recruiter`.`last_login` IS NOT NULL
  AND COALESCE(INET6_ATON(CONCAT('::ffff:', `recruit`.`last_ip`)), INET6_ATON(`recruit`.`last_ip`))
    = COALESCE(INET6_ATON(CONCAT('::ffff:', `recruiter`.`last_ip`)), INET6_ATON(`recruiter`.`last_ip`))
  AND COALESCE(INET6_ATON(CONCAT('::ffff:', `recruit`.`last_ip`)), INET6_ATON(`recruit`.`last_ip`))
    NOT IN (INET6_ATON('::'), INET6_ATON('::ffff:0.0.0.0'));

-- By leewheel 2026年11月12日 只有本轮真的查出要清理的账号时才推代次；查不到就不动（幂等）
UPDATE `raf_link_lock` SET `generation` = `generation` + 1
WHERE `id` = 1 AND EXISTS (SELECT 1 FROM `raf_same_ip_recruits`);

DELETE `progress` FROM `raf_progress` `progress`
JOIN `raf_same_ip_recruits` `blocked` ON `blocked`.`account_id` = `progress`.`account_id`;

DELETE `registration` FROM `raf_accounts` `registration`
JOIN `raf_same_ip_recruits` `blocked` ON `blocked`.`account_id` = `registration`.`account_id`;

UPDATE `account` `recruit`
JOIN `raf_same_ip_recruits` `blocked` ON `blocked`.`account_id` = `recruit`.`id`
SET `recruit`.`recruiter` = 0;

COMMIT;

DROP TEMPORARY TABLE `raf_same_ip_recruits`;
-- End By leewheel
