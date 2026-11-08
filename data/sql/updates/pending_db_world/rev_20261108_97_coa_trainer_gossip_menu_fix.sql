-- By leewheel 2026年11月8日
-- 修两个训练师的 gossip 菜单指向：gossip_menu 里只有问候语（npc_text），gossip_menu_option 里一条选项都没有。
-- 运行时本来就会回落到 MenuID 0（等于把 gossip_menu_id 当 0 用），但启动日志每次都会刷两条
--   "Trainer creature template references GossipMenuId ... has no gossip_menu_option entries."
-- 这里直接把这两个模板的 gossip_menu_id 归零，让数据与运行期实际行为一致：
--   164166 Blacksmith Peltran -> 1200352
--   164595 Zelda              -> 9920065
-- 行为零变化（原本就回落到 MenuID 0 的训练师选项），只是日志不再报警。
-- End By leewheel

UPDATE `creature_template`
SET `gossip_menu_id` = 0
WHERE `entry` IN (164166, 164595)
  AND `gossip_menu_id` IN (1200352, 9920065);
