-- mod-coa-challenges：上游新增的两条规则提示（国度银行限制、高风险战利品限制）纳入 module_string 体系。
-- 只增不改：195 = NO_REALM_BANK，196 = NO_HIGH_RISK_LOOT；顺带把此前只存在于数据库、未进仓库的 194 补齐。
-- By leewheel 2026年11月04日
INSERT INTO `module_string` (`module`, `id`, `string`) VALUES
('mod-coa-challenges', 194, 'Your active challenge requires PvE mode.'),
('mod-coa-challenges', 195, 'Your challenge forbids using the realm bank.'),
('mod-coa-challenges', 196, 'Your challenge forbids looting the spoils of other players in High-Risk.')
ON DUPLICATE KEY UPDATE `string` = VALUES(`string`);

INSERT INTO `module_string_locale` (`module`, `id`, `locale`, `string`) VALUES
('mod-coa-challenges', 194, 'zhCN', '你当前进行中的挑战需要 PVE 模式。'),
('mod-coa-challenges', 195, 'zhCN', '你的挑战禁止使用国度银行。'),
('mod-coa-challenges', 195, 'zhTW', '你的挑戰禁止使用國度銀行。'),
('mod-coa-challenges', 195, 'koKR', '당신의 도전은 렐름 은행 사용을 금지합니다.'),
('mod-coa-challenges', 195, 'frFR', 'Votre défi interdit l''utilisation de la banque de royaume.'),
('mod-coa-challenges', 195, 'deDE', 'Deine Herausforderung verbietet die Nutzung der Realm-Bank.'),
('mod-coa-challenges', 195, 'esES', 'Tu desafío prohíbe usar el banco del reino.'),
('mod-coa-challenges', 195, 'esMX', 'Tu desafío prohíbe usar el banco del reino.'),
('mod-coa-challenges', 195, 'ruRU', 'Ваше испытание запрещает использовать банк мира.'),
('mod-coa-challenges', 196, 'zhCN', '你的挑战禁止拾取其他玩家在高风险状态下的战利品。'),
('mod-coa-challenges', 196, 'zhTW', '你的挑戰禁止拾取其他玩家在高風險狀態下的戰利品。'),
('mod-coa-challenges', 196, 'koKR', '당신의 도전은 다른 플레이어의 고위험 전리품 획득을 금지합니다.'),
('mod-coa-challenges', 196, 'frFR', 'Votre défi interdit de piller le butin des autres joueurs en Haut Risque.'),
('mod-coa-challenges', 196, 'deDE', 'Deine Herausforderung verbietet das Plündern der Beute anderer Spieler im Hochrisiko-Modus.'),
('mod-coa-challenges', 196, 'esES', 'Tu desafío prohíbe saquear el botín de otros jugadores en Alto Riesgo.'),
('mod-coa-challenges', 196, 'esMX', 'Tu desafío prohíbe saquear el botín de otros jugadores en Alto Riesgo.'),
('mod-coa-challenges', 196, 'ruRU', 'Ваше испытание запрещает подбирать добычу других игроков в режиме высокого риска.')
ON DUPLICATE KEY UPDATE `string` = VALUES(`string`);
-- End By leewheel
