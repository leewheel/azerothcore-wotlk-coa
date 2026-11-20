-- #12920 风暴束缚者的「风暴束缚」（707542）：「导流造成的伤害现在有 60% 概率召唤雷电宝珠」。
-- 实战中导流（567560）永远是触发施法（洪流、暴雨之怒），而 proc 行若没有
-- PROC_ATTR_TRIGGERED_CAN_PROC（2）就会忽略触发法术，所以雷电宝珠从不出现。
-- 本次给该行补上该属性（AttributesMask = 2）。本脚本无玩家可见文本。
-- By leewheel 20261120
-- End By leewheel
UPDATE `spell_proc` SET `AttributesMask` = 2 WHERE `SpellId` = 707542;
