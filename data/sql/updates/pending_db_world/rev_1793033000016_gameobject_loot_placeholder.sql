-- 为 16 个引用缺失 loot 模板的 gameobject 补 gameobject_loot_template 占位条目
-- 核心 LootMgr 报 'Table gameobject_loot_template Entry N does not exist but it is used by Gameobject N'
-- 占位行 Chance=0.000001%（实际永不掉落，等同原行为：开箱无掉落），待内容组补充真实掉落后覆盖
-- By leewheel 2026年10月26日
INSERT IGNORE INTO gameobject_loot_template (Entry,Item,Reference,Chance,QuestRequired,LootMode,GroupId,MinCount,MaxCount,Comment) VALUES (90044,33470,0,0.000001,0,1,0,1,1,'Placeholder for missing GO loot');
INSERT IGNORE INTO gameobject_loot_template (Entry,Item,Reference,Chance,QuestRequired,LootMode,GroupId,MinCount,MaxCount,Comment) VALUES (90642,33470,0,0.000001,0,1,0,1,1,'Placeholder for missing GO loot');
INSERT IGNORE INTO gameobject_loot_template (Entry,Item,Reference,Chance,QuestRequired,LootMode,GroupId,MinCount,MaxCount,Comment) VALUES (93002,33470,0,0.000001,0,1,0,1,1,'Placeholder for missing GO loot');
INSERT IGNORE INTO gameobject_loot_template (Entry,Item,Reference,Chance,QuestRequired,LootMode,GroupId,MinCount,MaxCount,Comment) VALUES (99018,33470,0,0.000001,0,1,0,1,1,'Placeholder for missing GO loot');
INSERT IGNORE INTO gameobject_loot_template (Entry,Item,Reference,Chance,QuestRequired,LootMode,GroupId,MinCount,MaxCount,Comment) VALUES (101912,33470,0,0.000001,0,1,0,1,1,'Placeholder for missing GO loot');
INSERT IGNORE INTO gameobject_loot_template (Entry,Item,Reference,Chance,QuestRequired,LootMode,GroupId,MinCount,MaxCount,Comment) VALUES (101913,33470,0,0.000001,0,1,0,1,1,'Placeholder for missing GO loot');
INSERT IGNORE INTO gameobject_loot_template (Entry,Item,Reference,Chance,QuestRequired,LootMode,GroupId,MinCount,MaxCount,Comment) VALUES (101914,33470,0,0.000001,0,1,0,1,1,'Placeholder for missing GO loot');
INSERT IGNORE INTO gameobject_loot_template (Entry,Item,Reference,Chance,QuestRequired,LootMode,GroupId,MinCount,MaxCount,Comment) VALUES (111017,33470,0,0.000001,0,1,0,1,1,'Placeholder for missing GO loot');
INSERT IGNORE INTO gameobject_loot_template (Entry,Item,Reference,Chance,QuestRequired,LootMode,GroupId,MinCount,MaxCount,Comment) VALUES (518367,33470,0,0.000001,0,1,0,1,1,'Placeholder for missing GO loot');
INSERT IGNORE INTO gameobject_loot_template (Entry,Item,Reference,Chance,QuestRequired,LootMode,GroupId,MinCount,MaxCount,Comment) VALUES (835958,33470,0,0.000001,0,1,0,1,1,'Placeholder for missing GO loot');
INSERT IGNORE INTO gameobject_loot_template (Entry,Item,Reference,Chance,QuestRequired,LootMode,GroupId,MinCount,MaxCount,Comment) VALUES (1344096,33470,0,0.000001,0,1,0,1,1,'Placeholder for missing GO loot');
INSERT IGNORE INTO gameobject_loot_template (Entry,Item,Reference,Chance,QuestRequired,LootMode,GroupId,MinCount,MaxCount,Comment) VALUES (2300516,33470,0,0.000001,0,1,0,1,1,'Placeholder for missing GO loot');
INSERT IGNORE INTO gameobject_loot_template (Entry,Item,Reference,Chance,QuestRequired,LootMode,GroupId,MinCount,MaxCount,Comment) VALUES (9301253,33470,0,0.000001,0,1,0,1,1,'Placeholder for missing GO loot');
INSERT IGNORE INTO gameobject_loot_template (Entry,Item,Reference,Chance,QuestRequired,LootMode,GroupId,MinCount,MaxCount,Comment) VALUES (9301254,33470,0,0.000001,0,1,0,1,1,'Placeholder for missing GO loot');
INSERT IGNORE INTO gameobject_loot_template (Entry,Item,Reference,Chance,QuestRequired,LootMode,GroupId,MinCount,MaxCount,Comment) VALUES (9301255,33470,0,0.000001,0,1,0,1,1,'Placeholder for missing GO loot');
INSERT IGNORE INTO gameobject_loot_template (Entry,Item,Reference,Chance,QuestRequired,LootMode,GroupId,MinCount,MaxCount,Comment) VALUES (9301256,33470,0,0.000001,0,1,0,1,1,'Placeholder for missing GO loot');