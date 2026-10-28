-- 门禁运行时错误批量修复（r2 门禁 2026-10-28 排查结论）
-- By leewheel 2026年10月28日
--
-- ① creature_model_info 缺失 53 行（43 个 distinct display，加载器 "No model data exist"）：
--    取值规则 = 同 ModelId 且已有 cmi 行的兄弟 display 复制；无兄弟时默认 1,1,2,0
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (67233,0.91665,3.04692,2,0); -- ents 34656 sib:37332
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (67267,0.91665,3.04692,2,0); -- ents 34651 sib:37332
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (75730,1,1,2,0); -- ents 80540 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (76574,2,2.56,2,0); -- ents 43478 sib:479
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (77218,2,2.56,2,0); -- ents 43565 sib:479
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (78509,1,1,2,0); -- ents 80888 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (79485,1,1,2,0); -- ents 80391 sib:74900
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (79486,1,1,2,0); -- ents 80392 sib:74900
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (79487,1,1,2,0); -- ents 80393 sib:74900
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (83160,1,1,2,0); -- ents 43318 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (89251,1,1,2,0); -- ents 80539,80541 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (92345,1,1,2,0); -- ents 49413 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (94074,1,1,2,0); -- ents 377942 (Conduit) default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (95128,0.389,1.5,2,0); -- ents 94058 sib:90773
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (201116,1,1,2,0); -- ents 254517 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (201130,1,1,2,0); -- ents 254515 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (201132,1,1,2,0); -- ents 254490 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (220510,1,1,2,0); -- ents 492179 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (280071,1.24,8,2,0); -- ents 250042 sib:27408
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (328641,0.93,9,0,0); -- ents 80227,80228,80229 sib:28641
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (405063,1,1,2,0); -- ents 94054 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (405064,1,1,2,0); -- ents 94055 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (411106,1,1,2,0); -- ents 9370003 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (411372,1,1,2,0); -- ents 411372 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (421460,1,1,2,0); -- ents 421460 (Natural Disguise) default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (427990,1,1,2,0); -- ents 397771 default（r2 唯一报错行）
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (461007,1,1,2,0); -- ents 50268 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (462071,1,1,2,0); -- ents 462071 (Hemostasis) default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (600003,1,2,2,0); -- ents 80642,80643,180642,180643,280642,280643,380642,380643 sib:100003
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (945291,2.03128,1,2,0); -- ents 10500004 sib:945292
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (945296,0.6111,2.031,2,0); -- ents 10500000 sib:945295
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (945446,1,1,2,0); -- ents 500150 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (945447,1,1,2,0); -- ents 500149 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (945448,1,1,2,0); -- ents 500148 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (945449,1,1,2,0); -- ents 500147 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (945450,1,1,2,0); -- ents 500146 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (945476,1,1,2,0); -- ents 11000087 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (945494,0.73332,2.4372,2,0); -- ents 11000100 sib:945492
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (945498,0.73332,2.4372,2,0); -- ents 11000104 sib:945492
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (945539,1,1,2,0); -- ents 11000159 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (945542,0.366667,1.21877,2,0); -- ents 11000164 sib:105404
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (945580,1,1,2,0); -- ents 11000222 default
INSERT IGNORE INTO creature_model_info (DisplayID,BoundingRadius,CombatReach,Gender,DisplayID_Other_Gender) VALUES (945581,1,1,2,0); -- ents 11000223 default

-- ② GO 195002 Thunderkeg 模板补回（spell 807849 Stormbringer TRANS_DOOR 引用；rev_1793033000030 误删，rev_20260930_93 为准）
INSERT INTO gameobject_template (`entry`, `type`, `displayId`, `name`, `size`) VALUES
(195002, 22, 1013445, 'Thunderkeg', 1)
ON DUPLICATE KEY UPDATE `type` = VALUES(`type`), `displayId` = VALUES(`displayId`),
`name` = VALUES(`name`), `size` = VALUES(`size`);

-- ③ GO 2300811 Yak Dung：AIName=SmartGameObjectAI 但无任何 smart_scripts → 清 AIName
UPDATE gameobject_template SET AIName = '' WHERE entry = 2300811 AND AIName = 'SmartGameObjectAI';

-- ④ SmartAI 164420 (Ealdfrost Yak) Event 2 Action 67 (CREATE_TIMED_EVENT)：
--    (id=0, InitialMin=60000, InitialMax=0) min/max 颠倒被校验跳过；
--    且 Event 3 (TIMED_EVENT_TRIGGERED) 等待的是 timed event id=1，
--    故同时把创建 id 改为 1、InitialMax 补 60000（60 秒后单次触发）
UPDATE smart_scripts SET action_param1 = 1, action_param3 = 60000
WHERE entryorguid = 164420 AND source_type = 0 AND id = 2 AND action_type = 67;

-- ⑤ 坏子池 chance 修复：15661-15665(Feralas)/15889-15896(Thousand Needles) 矿脉池
--    各只有 1 个成员且 chance=10（和≠100 被判坏池）→ 置 100（该点位必出该矿）
UPDATE pool_gameobject SET chance = 100 WHERE pool_entry IN
(15661,15662,15663,15664,15665,15889,15890,15891,15892,15893,15894,15895,15896);

-- ⑥ Zangarmarsh 空父池清理：8061/8075 在 pool_template 有模板但子池 8057-8060/8071-8074
--    均不在 pool_template 且全体无成员（上游 base 同样无成员，属死数据）→
--    删父子关系 + 父模板，消除 "orphan pool_pool" 8 条与 "Pool X is empty" 2 条
DELETE FROM pool_pool WHERE pool_id IN (8057,8058,8059,8060,8071,8072,8073,8074);
DELETE FROM pool_template WHERE entry IN (8061, 8075);

-- ⑦ graveyard_zone：GhostZone 3455 "The North Sea"（Pale Reach/Scadeald 周边海域，map0）无任何
--    墓地链接 → 阵亡释放时报 "Table graveyard_zone incomplete: Zone 3455 Team 1"。
--    复用 Pale Reach 全部 8 个自定义墓地（6091-6098），Faction=0 双阵营，按距离就近释放
INSERT IGNORE INTO graveyard_zone (ID, GhostZone, Faction, Comment) VALUES
(6091, 3455, 0, 'The North Sea - Pale Reach, Scadeald - Cresthairn'),
(6092, 3455, 0, 'The North Sea - Pale Reach, Scadeald - Dunshire'),
(6093, 3455, 0, 'The North Sea - Pale Reach, Scadeald - Andraste''s Fortress'),
(6094, 3455, 0, 'The North Sea - Pale Reach, Scadeald - Scadeald Heights'),
(6095, 3455, 0, 'The North Sea - Pale Reach, Scadeald - Namarien'),
(6096, 3455, 0, 'The North Sea - Pale Reach, Scadeald - Ealdfrost Foothills'),
(6097, 3455, 0, 'The North Sea - Pale Reach, Scadeald - Snowveil'),
(6098, 3455, 0, 'The North Sea - Pale Reach, Scadeald - Hallow Wind Hanging Abbey');
