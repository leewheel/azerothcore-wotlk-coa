-- By leewheel 20261125
-- 2026-11-25 上游合并批次的玩家可见文本简体中文补全
-- 原则：不改上游 SQL 的任何一行一列，全部用 locale 覆盖表与说明表收口，
--       上游下次再动这些文件也不会冲突，updates 的 SHA1 hash 始终对得上。
-- 覆盖内容：
--   1) 荒野之地新增任务链的 5 个生物名、1 个物件名（萨卡里 / 雷蹄长老 / 水晶等）
--   2) 任务 254014 最后一块、254015 逆转、500007 最初步伐的标题与正文
--   3) 太阳牧师 / 焚誓者等 4 条新法术说明（coa_client_spell_description）
-- 占位符 ${...} / $m1 / $s1 / $d / $i / $a1 / \r\n 原样保留，仅为文字汉化。

-- ============================================================
-- 1) 生物名称与头衔
-- ============================================================
-- 254014 Sakari / 254016 Queen Erethina：荒野之地萨卡里任务线
-- 764578 Elder Thunderhoof / 764666 Baby Thunderhead：最初步伐护送任务
-- 9935000 [TG] Little Mickey's Flask Skull：白手套恶作剧的幽灵头骨（调试标记生物）
DELETE FROM `creature_template_locale` WHERE `entry` IN (254014, 254016, 764578, 764666, 9935000) AND `locale` = 'zhCN';
INSERT INTO `creature_template_locale` (`entry`, `locale`, `Name`, `Title`, `VerifiedBuild`) VALUES
(254014, 'zhCN', '萨卡里', NULL, 0),
(254016, 'zhCN', '埃雷希娜女王', NULL, 0),
(764578, 'zhCN', '雷蹄长老', NULL, 0),
(764666, 'zhCN', '幼年雷蹄兽', NULL, 0),
(9935000, 'zhCN', '[TG] 小米奇烧瓶头骨', NULL, 0)
ON DUPLICATE KEY UPDATE `Name` = VALUES(`Name`), `Title` = VALUES(`Title`);

-- 物件名 254002 Ouru'gai Crystal
DELETE FROM `gameobject_template_locale` WHERE `entry` = 254002 AND `locale` = 'zhCN';
INSERT INTO `gameobject_template_locale` (`entry`, `locale`, `name`, `castBarCaption`, `VerifiedBuild`) VALUES
(254002, 'zhCN', '奥鲁盖水晶', NULL, 0)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `castBarCaption` = VALUES(`castBarCaption`);

-- ============================================================
-- 2) 任务文本（Title / Details / Objectives / CompletedText / ObjectiveText1）
--    空字段保持 NULL，不覆盖客户端已有的空串。
-- ============================================================
DELETE FROM `quest_template_locale` WHERE `ID` IN (254014, 254015, 500007) AND `locale` = 'zhCN';
INSERT INTO `quest_template_locale`
(`ID`, `locale`, `Title`, `Details`, `Objectives`, `EndText`, `CompletedText`, `ObjectiveText1`, `VerifiedBuild`)
VALUES
-- 254014 最后一块
(254014, 'zhCN', '最后一块',
 '在荒野之地找到奥鲁盖水晶。',
 '唉，我不知道这些传说的源头究竟有多真，但故事总得有个出处，如果它真有强大的驱咒功效，那就说得通了。不过用炼金手段替代的话，也许能把它稀释成好几份解药，虽然数量也不会多。这朵花只有一颗种子，但也许我能想办法让它长出更多……啊，我想得太远了。我们得先确认这套方法到底管不管用。你已经陪我走到这一步了，如果你能拿到鹰身人提到的那块水晶，完成后带着它在荒野之地来见我，我相信可以用恶魔之血为引，让它附着在我们自己的恶魔之血上并将其抵消。',
 NULL,
 '在荒野之地与萨卡里交谈',
 NULL, 0),
-- 254015 逆转
(254015, 'zhCN', '逆转',
 '观看萨卡里配制解药。',
 '好，我相信我大致理解了这一切的特性。我只有一次机会，所以最好让它成功。没有你我做不到这件事，所以你至少该留下来亲眼看着它完成。',
 NULL,
 '在荒野之地与萨卡里交谈',
 '逆转过程已观察', 0),
-- 500007 最初步伐
(500007, 'zhCN', '最初步伐',
 '有三头幼年雷蹄兽与兽群走散了。把它们平安送回平原圣地。',
 '科多兽在这片土地上行走的时间比我们任何人都长。它们的脚步把荒野之地雕琢成了如今的样子。我从小就跟随着它们，学习兽群的习性，以及它们一代代流传下来的故事。可是出事了。小牛犊变少了，风里也听不到它们的叫声。我看到兽群在躁动不安、残缺不全地迁徙。南边，在巨人平原，大地被不属于这里的东西搅动起来了。异种虫的隧道尖锐而错乱，离牧场太近了。我担心幼兽被抓走或者走散了。如果你发现还活着的小牛犊，把它们带回家。如果有倒下的，别让它们被带到更深处。让兽群重新恢复平衡吧。在你做到之前，荒野之地会一直感受到它们的缺席。',
 NULL,
 '回到荒野之地平原圣地的雷蹄长老身边',
 '幼年雷蹄兽已护送', 0);

-- ============================================================
-- 3) 新法术说明（服务端下发客户端的法术描述，占位符原样保留）
-- ============================================================
DELETE FROM `coa_client_spell_description` WHERE `ID` IN (802678, 570159, 804247, 572848);
INSERT INTO `coa_client_spell_description` (`ID`, `Description`, `ToolTip`) VALUES
-- 802678  Felstrike 灼魔打击（原 rev_20261124_01）
(802678, '灼烧敌人，在 $d 内造成 ${($d*1000/$T1)*($802678m1+$802678ppl1+$SP*.05)} 点暗影烈焰伤害，最多叠加 $u 次。', NULL),
-- 570159  Scars of Suffering 折磨伤痕（原 rev_20261124_01）
(570159, '', '攻击者对此目标造成 ${$AGI*0.15} 点提高的攻击强度。'),
-- 804247  Sun Cleric 祝福（原 rev_20261121_01）
(804247, '祝福你与一名盟友，在 5 分钟内每 10 秒恢复其最大生命值的 5% 与你最大法力值的 5%。\r\n\r\n同一时间只能影响 1 名盟友。',
 '已祝福。每 10 秒为太阳牧师的目标恢复其最大生命值的 5%，并为太阳牧师恢复 5% 最大法力值。'),
-- 572848  Justice 正义（原 rev_20261123_300，双手分别计算）
(572848, '旋身以双武器攻击，对 $a1 码内最多 $i 名敌人造成 $524857s1% 武器伤害。\r\n\r\n你的主手攻击额外造成 ${$572850m2+$spfi*0.2} 点物理伤害，副手攻击额外造成 ${$572045m2+$spfi*0.2} 点火焰伤害。', NULL);

-- End By leewheel
