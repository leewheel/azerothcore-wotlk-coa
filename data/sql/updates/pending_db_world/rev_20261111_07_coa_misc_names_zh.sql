-- 全库可见英文补全（第 5 批）：零星名称
-- By leewheel 2026年11月11日
--
-- 说明：全库审计后，生物名 / 物件名里「是英文且缺中文」的 3700 余条，
--       逐条核对后 99% 以上是不可见内部件，实测过滤（触发器 / 击杀计数标记 /
--       [DND] 事件件 / 装饰模型 / 纯网格名）后只剩个位数会真正显示给玩家。
--       本批把那几个真正可见的补上；装饰模型与不可见触发器不译（它们没有名字显示）。

-- 1) 生物：加百列·烟囱（COA 自定义 NPC，会显示名字）
INSERT INTO `creature_template_locale` (`entry`, `locale`, `Name`) VALUES
(449401, 'zhCN', '加百列·烟囱')
ON DUPLICATE KEY UPDATE `Name` = VALUES(`Name`);

-- 2) 物件：可交互的木桶 / 木箱 / 啤酒桶 / 书籍类
INSERT INTO `gameobject_template_locale` (`entry`, `locale`, `name`) VALUES
(179967, 'zhCN', '木桶'),
(184863, 'zhCN', '木桶'),
(195198, 'zhCN', '木箱'),
(179971, 'zhCN', '精灵木箱'),
(179976, 'zhCN', '啤酒桶'),
(202889, 'zhCN', '巨魔典籍')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- End By leewheel
