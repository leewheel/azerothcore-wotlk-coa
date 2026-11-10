-- 修正中文文本里的「字面量转义换行」
-- By leewheel 2026年11月11日
--
-- 问题：此前批量灌入的中文里，换行被写成了两个字面字符「反斜杠 + n」，
--       客户端不会把它当换行，而是原样显示成 \n，正文挤成一整段。
-- 范围：字节级核对（INSTR 查找 0x5C6E），共 906 行：
--       物品描述 778、任务详情 114、任务目标 5、任务完成日志 9。
-- 处理：把字面量「反斜杠 n」换成真正的换行符；顺带处理「反斜杠 r」与「反斜杠 t」。
--       纯文本列，不涉及协议串（协议串在 description 以 @ 开头的那批里，不含转义序列）。

UPDATE `item_template_locale`
SET `Description` = REPLACE(REPLACE(REPLACE(`Description`, CHAR(92, 114, 92, 110), CHAR(10)),
                                   CHAR(92, 114), ''), CHAR(92, 110), CHAR(10))
WHERE `locale` = 'zhCN' AND INSTR(`Description`, CHAR(92, 110)) > 0;

UPDATE `quest_template_locale`
SET `Details` = REPLACE(REPLACE(REPLACE(`Details`, CHAR(92, 114, 92, 110), CHAR(10)),
                                CHAR(92, 114), ''), CHAR(92, 110), CHAR(10))
WHERE `locale` = 'zhCN' AND INSTR(`Details`, CHAR(92, 110)) > 0;

UPDATE `quest_template_locale`
SET `Objectives` = REPLACE(REPLACE(REPLACE(`Objectives`, CHAR(92, 114, 92, 110), CHAR(10)),
                                   CHAR(92, 114), ''), CHAR(92, 110), CHAR(10))
WHERE `locale` = 'zhCN' AND INSTR(`Objectives`, CHAR(92, 110)) > 0;

UPDATE `quest_template_locale`
SET `CompletedText` = REPLACE(REPLACE(REPLACE(`CompletedText`, CHAR(92, 114, 92, 110), CHAR(10)),
                                      CHAR(92, 114), ''), CHAR(92, 110), CHAR(10))
WHERE `locale` = 'zhCN' AND INSTR(`CompletedText`, CHAR(92, 110)) > 0;

-- End By leewheel
