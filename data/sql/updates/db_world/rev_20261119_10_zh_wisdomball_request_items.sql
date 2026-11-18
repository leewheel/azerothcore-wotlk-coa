-- 2026.11.19 智慧球任务“交任务对话”汉化（quest_request_items 94171xx）
-- 玩家交任务时 NPC 说的话，原为英文，补 zhCN。By leewheel 20261119
DELETE FROM `quest_request_items_locale` WHERE `locale` = 'zhCN' AND `ID` BETWEEN 9417101 AND 9417117;
INSERT INTO `quest_request_items_locale` (`ID`, `locale`, `CompletionText`, `VerifiedBuild`) VALUES
(9417102, 'zhCN', '怎么样？它说了什么？', 0),
(9417103, 'zhCN', '那些书页，$N。每一页都重要。', 0),
(9417104, 'zhCN', '找到了吗？我老师的笔迹不会认错。', 0),
(9417106, 'zhCN', '守护结界给你看了什么？', 0),
(9417107, 'zhCN', '他们囤的每一块碎片，都是封印上的一道裂缝。', 0),
(9417108, 'zhCN', '你……你看得见我？', 0),
(9417109, 'zhCN', '锚点还撑得住吗？', 0),
(9417110, 'zhCN', '挡住他们，$N！我快好了！', 0),
(9417111, 'zhCN', '听他们。他们已经等了很久。', 0),
(9417112, 'zhCN', '锁链撑不了多久了。', 0),
(9417113, 'zhCN', '你和他们交手了吗？全部？', 0),
(9417114, 'zhCN', '是……是有人在那儿吗？', 0),
(9417115, 'zhCN', '先解决那只先驱，$N。然后我们就离开她的梦。', 0),
(9417116, 'zhCN', '撑住了吗？', 0);
-- End By leewheel
