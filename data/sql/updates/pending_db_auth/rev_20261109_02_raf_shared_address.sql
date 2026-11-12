-- Recruit-A-Friend links made between accounts on the same IP address record that address,
-- so RecruitAFriend.SharedAddressLinks can cap how many such links one address holds.
-- By leewheel 2026年11月12日 幂等化：更新器（启动器）每次更新都会把包内 SQL 全量重导一遍，
-- 原来的裸 ALTER 在第二遍就报 1060 Duplicate column 并让整包中止。
-- MySQL 没有 ADD COLUMN IF NOT EXISTS，改为先查 information_schema 再决定是否执行；
-- 表还没建（全新库，核心启动时才建 raf_accounts）时也跳过，不要用 1146 打断整包。
SELECT IF(
    EXISTS(SELECT 1 FROM `information_schema`.`columns` WHERE `table_schema` = DATABASE()
        AND `table_name` = 'raf_accounts' AND `column_name` = 'shared_address'),
    'DO 0',
    IF(
        EXISTS(SELECT 1 FROM `information_schema`.`tables` WHERE `table_schema` = DATABASE()
            AND `table_name` = 'raf_accounts'),
        'ALTER TABLE `raf_accounts`
           ADD COLUMN `shared_address` VARCHAR(45) DEFAULT NULL,
           ADD KEY `shared_address` (`shared_address`)',
        'DO 0'
    )
) INTO @coa_raf_shared_address_sql;
PREPARE coa_raf_shared_address FROM @coa_raf_shared_address_sql;
EXECUTE coa_raf_shared_address;
DEALLOCATE PREPARE coa_raf_shared_address;
-- End By leewheel
