-- mod-coa-mythic-plus: two GM strings the upstream merge brought in
-- (rev 5279c4c1e, the RDF / LFG / Mythic+ batch), localized the same day so
-- the module stays fully translated. Ids 87-88 of the MythicStrings enum.

DELETE FROM `module_string` WHERE `module` = 'mod-coa-mythic-plus' AND `id` IN (87, 88);
DELETE FROM `module_string_locale` WHERE `module` = 'mod-coa-mythic-plus' AND `id` IN (87, 88);

INSERT INTO `module_string` (`module`, `id`, `string`) VALUES
('mod-coa-mythic-plus', 87, 'No Mythic+ run is under way there.'),
('mod-coa-mythic-plus', 88, 'Mythic+: {} s of {} s elapsed.');

INSERT INTO `module_string_locale` (`module`, `id`, `locale`, `string`) VALUES
('mod-coa-mythic-plus', 87, 'koKR', '해당 위치에 진행 중인 신화+ 없습니다.'),
('mod-coa-mythic-plus', 88, 'koKR', '신화+: {} / {} 초 경과.'),
('mod-coa-mythic-plus', 87, 'frFR', 'Aucune course Mythique + n''est en cours là-bas.'),
('mod-coa-mythic-plus', 88, 'frFR', 'Mythique + : {} s sur {} s écoulées.'),
('mod-coa-mythic-plus', 87, 'deDE', 'Dort läuft keine Mythisch+-Runde.'),
('mod-coa-mythic-plus', 88, 'deDE', 'Mythisch+: {} s von {} s vergangen.'),
('mod-coa-mythic-plus', 87, 'zhCN', '那里没有正在进行的大秘境。'),
('mod-coa-mythic-plus', 88, 'zhCN', '大秘境：已用 {} / {} 秒。'),
('mod-coa-mythic-plus', 87, 'zhTW', '那裡沒有正在進行的大秘境。'),
('mod-coa-mythic-plus', 88, 'zhTW', '大秘境：已用 {} / {} 秒。'),
('mod-coa-mythic-plus', 87, 'esES', 'No hay ninguna carrera Mítica+ en curso allí.'),
('mod-coa-mythic-plus', 88, 'esES', 'Mítica+: {} s de {} s transcurridos.'),
('mod-coa-mythic-plus', 87, 'esMX', 'No hay ninguna carrera Mítica+ en curso allí.'),
('mod-coa-mythic-plus', 88, 'esMX', 'Mítica+: {} s de {} s transcurridos.'),
('mod-coa-mythic-plus', 87, 'ruRU', 'Там нет активного забега Мифик+.'),
('mod-coa-mythic-plus', 88, 'ruRU', 'Мифик+: прошло {} из {} с.');
