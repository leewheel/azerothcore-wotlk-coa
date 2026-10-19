-- mod-coa-mythic-plus: the gossip greetings of Edrim Skysong (TEXT_EDRIM,
-- 9416000) and Markus / Mar'toge (TEXT_MARKUS, 9414500).
--
-- These npc_text rows never existed: SendGossipMenuFor was called with these
-- two ids while only the npc_vendor entries of the same numbers were ever
-- inserted (rev_20261007_92_mythic_plus_vendors.sql), so the greeting area of
-- both gossip windows rendered empty. This file creates the rows and carries
-- every locale the core supports: enUS in npc_text, the rest in
-- npc_text_locale - the same split the core uses everywhere.

DELETE FROM `npc_text` WHERE `ID` IN (9416000, 9414500);
DELETE FROM `npc_text_locale` WHERE `ID` IN (9416000, 9414500);

INSERT INTO `npc_text` (`ID`, `text0_0`, `text0_1`, `VerifiedBuild`) VALUES
(9416000, 'Mythic items, by slot. Bring Mythic Coins.', NULL, 1),
(9414500, 'Marks of Triumph and Heroic Dungeon items, by slot.', NULL, 1);

INSERT INTO `npc_text_locale` (`ID`, `Locale`, `Text0_0`) VALUES
(9416000, 'koKR', '부위별 신화 아이템. 신화 코인을 가져오세요.'),
(9416000, 'frFR', 'Objets mythiques, par emplacement. Apportez des pièces mythiques.'),
(9416000, 'deDE', 'Mythische Gegenstände, nach Slot. Bring Mythisch-Münzen mit.'),
(9416000, 'zhCN', '大秘境物品，按部位分类。请带上大秘境币。'),
(9416000, 'zhTW', '大秘境物品，依部位分類。請帶上大秘境幣。'),
(9416000, 'esES', 'Objetos míticos, por ranura. Trae Monedas Míticas.'),
(9416000, 'esMX', 'Objetos míticos, por ranura. Trae Monedas Míticas.'),
(9416000, 'ruRU', 'Мифические предметы по слотам. Приносите мифические монеты.'),
(9414500, 'koKR', '승리의 문장과 영웅 지하성 아이템을 부위별로.'),
(9414500, 'frFR', 'Marques de triomphe et objets de donjon héroïque, par emplacement.'),
(9414500, 'deDE', 'Marken des Triumphs und heldenhafte Dungeon-Gegenstände, nach Slot.'),
(9414500, 'zhCN', '凯旋徽章和英雄地下城物品，按部位分类。'),
(9414500, 'zhTW', '凱旋徽章和英雄地城物品，依部位分類。'),
(9414500, 'esES', 'Marcas de Triunfo y objetos de mazmorra heroica, por ranura.'),
(9414500, 'esMX', 'Marcas de Triunfo y objetos de mazmorra heroica, por ranura.'),
(9414500, 'ruRU', 'Знаки триумфа и предметы героических подземелий по слотам.');
