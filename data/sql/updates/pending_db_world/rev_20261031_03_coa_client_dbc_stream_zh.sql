-- 上游 #9844 客户端 DBC 流（map/mapdifficulty/gameobjectdisplayinfo）中文化
-- mapdifficulty_dbc.Message 经 AscensionClientDbcStream 按会话 locale 下发给客户端；
-- zhCN 列为空时服务端回退 enUS 英文，此处补齐中文（map_dbc 保持空表，客户端地图名继续读 MPQ 中文 DBC）
-- #By leewheel 2026年10月29日
UPDATE `mapdifficulty_dbc`
SET `Message_Lang_zhCN` = '史诗难度需要你达到80级。'
WHERE `ID` IN (757, 758) AND (`Message_Lang_zhCN` IS NULL OR `Message_Lang_zhCN` = '');
