-- 主仓上游 2026-11-13 批次（7445a752da..HEAD，18 个提交）玩家可见文本汉化，只写 zhCN。
-- 上游 SQL 原件一行不动，全部由本补丁覆盖；全部幂等，可重复执行。
-- 覆盖对象：阿塔祖尔世界 Boss 的生物名 / 物件名 / 神龛旁白、Worldforged 装饰物件名、
--          圣殿骑士（Templar）17 条客户端法术说明。
-- By leewheel 20261113

-- 阿塔祖尔·噬魂者（世界 Boss）
INSERT INTO `creature_template_locale` (`entry`, `locale`, `Name`, `Title`, `VerifiedBuild`) VALUES
(978090, 'zhCN', '阿塔祖尔·噬魂者', '', 0)
ON DUPLICATE KEY UPDATE `Name` = VALUES(`Name`), `Title` = VALUES(`Title`);

-- 阿塔祖尔的神龛、传送门、灵魂容器祭坛
INSERT INTO `gameobject_template_locale` (`entry`, `locale`, `name`, `castBarCaption`, `VerifiedBuild`) VALUES
(978090, 'zhCN', '阿塔祖尔神龛', '', 0),
(978091, 'zhCN', '通往祖尔玛沙的传送门', '', 0),
(978092, 'zhCN', '阿塔祖尔神龛', '', 0),
(978093, 'zhCN', '灵魂容器祭坛', '', 0)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `castBarCaption` = VALUES(`castBarCaption`);

-- 手按上神龛时的那句旁白（首尾两段文本都要覆盖）
INSERT INTO `npc_text_locale` (`ID`, `Locale`, `Text0_0`, `Text0_1`) VALUES
(978090, 'zhCN',
 '当你把手按在神龛上、想与它的力量共鸣时，神龛似乎察觉到了你的存在。',
 '当你把手按在神龛上、想与它的力量共鸣时，神龛似乎察觉到了你的存在。')
ON DUPLICATE KEY UPDATE `Text0_0` = VALUES(`Text0_0`), `Text0_1` = VALUES(`Text0_1`);

-- Worldforged 编辑器第 7 批的装饰物件（场景道具，鼠标悬停可见）
INSERT INTO `gameobject_template_locale` (`entry`, `locale`, `name`, `castBarCaption`, `VerifiedBuild`) VALUES
(96088, 'zhCN', '巨魔头骨 2 摆件', '', 0),
(96089, 'zhCN', '巨魔头骨 3 摆件', '', 0),
(96090, 'zhCN', '巨魔骸骨摆件', '', 0),
(96091, 'zhCN', '巨魔骸骨臂摆件', '', 0),
(95988, 'zhCN', '破损的船摆件', '', 0),
(515580, 'zhCN', '破损的木箱摆件', '', 0),
(517315, 'zhCN', '旧护肩', '', 0)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `castBarCaption` = VALUES(`castBarCaption`);

-- 圣殿骑士客户端法术说明：只译文字，$ 变量、|cffffffff 色码、@s:xxx:0@ 标记、\r\n 换行全部原样保留
UPDATE `coa_client_spell_description` SET
 `Description` = '以圣光之力爆裂，对附近敌人造成 ${$803153m1+$803153ppl1+$AP*0.25+$sph*.25} 点神圣伤害，并且每 $t3 秒对附近敌人触发一次 |cffffffff狂热|r，持续 $d。@s:801450:0@\r\n\r\n激活期间，你的 |cffffffff神殿守卫|r 法术能量消耗降低 $s1%。',
 `ToolTip` = '每 $t3 秒对附近敌人造成 ${$803153m1+$803153ppl1+$AP*0.25+$sph*.25} 点神圣伤害，持续 $d。\r\n\r\n激活期间，你的 |cffffffff神殿守卫|r 法术能量消耗降低。'
WHERE `ID` = 500694;

UPDATE `coa_client_spell_description` SET
 `Description` = '对最多 $i 个附近敌人造成 ${$801832m1*$<scalingbp>+$sph*0.25+$AP*0.25} 点神圣伤害。\r\n\r\n对亡灵敌人必定造成爆击。',
 `ToolTip` = ''
WHERE `ID` = 801832;

UPDATE `coa_client_spell_description` SET
 `Description` = '造成武器伤害外加 ${$m1+0+$SP*0.3} 点伤害。',
 `ToolTip` = ''
WHERE `ID` IN (805410, 570200, 570201, 570202, 570203, 570204, 570205);

UPDATE `coa_client_spell_description` SET
 `Description` = '为目标 $a1 码内最多 $i 名友方小队或团队成员恢复 $?s803844[${$803844m1+$SP*0.35}][${$803159m1+$SP*0.35}] 点生命。',
 `ToolTip` = ''
WHERE `ID` = 803160;

UPDATE `coa_client_spell_description` SET
 `Description` = '释放旋转的 |cffffffff破誓者|r，每 $t1 秒对附近敌人造成 $805410s2% 武器伤害外加 ${$805410m1+$SP*0.3} 点伤害（受法术强度加成）$?s300512[，并使受到的伤害降低 $300512s2%][]，持续 $d。\r\n\r\n消耗你的 |cffffffff誓约|r，每消耗一层额外造成伤害。',
 `ToolTip` = '每 $t1 秒挥刀横扫，对附近敌人造成武器伤害外加 ${$805410m1+$SP*0.3} 点伤害。$?s300512[ 受到的伤害降低 $300512s2%。][]'
WHERE `ID` = 805409;

UPDATE `coa_client_spell_description` SET
 `Description` = '释放旋转的 |cffffffff破誓者|r，每 $t1 秒对附近敌人造成 $570200s2% 武器伤害外加 ${$570200m1+$SP*0.3} 点伤害（受法术强度加成）$?s300512[，并使受到的伤害降低 $300512s2%][]，持续 $d。\r\n\r\n消耗你的 |cffffffff誓约|r，每消耗一层额外造成伤害。',
 `ToolTip` = '每 $t1 秒挥刀横扫，对附近敌人造成武器伤害外加 ${$570200m1+$SP*0.3} 点伤害。$?s300512[ 受到的伤害降低 $300512s2%。][]'
WHERE `ID` = 807269;

UPDATE `coa_client_spell_description` SET
 `Description` = '释放旋转的 |cffffffff破誓者|r，每 $t1 秒对附近敌人造成 $570201s2% 武器伤害外加 ${$570201m1+$SP*0.3} 点伤害（受法术强度加成）$?s300512[，并使受到的伤害降低 $300512s2%][]，持续 $d。\r\n\r\n消耗你的 |cffffffff誓约|r，每消耗一层额外造成伤害。',
 `ToolTip` = '每 $t1 秒挥刀横扫，对附近敌人造成武器伤害外加 ${$570201m1+$SP*0.3} 点伤害。$?s300512[ 受到的伤害降低 $300512s2%。][]'
WHERE `ID` = 807270;

UPDATE `coa_client_spell_description` SET
 `Description` = '释放旋转的 |cffffffff破誓者|r，每 $t1 秒对附近敌人造成 $570202s2% 武器伤害外加 ${$570202m1+$SP*0.3} 点伤害（受法术强度加成）$?s300512[，并使受到的伤害降低 $300512s2%][]，持续 $d。\r\n\r\n消耗你的 |cffffffff誓约|r，每消耗一层额外造成伤害。',
 `ToolTip` = '每 $t1 秒挥刀横扫，对附近敌人造成武器伤害外加 ${$570202m1+$SP*0.3} 点伤害。$?s300512[ 受到的伤害降低 $300512s2%。][]'
WHERE `ID` = 807271;

UPDATE `coa_client_spell_description` SET
 `Description` = '释放旋转的 |cffffffff破誓者|r，每 $t1 秒对附近敌人造成 $570203s2% 武器伤害外加 ${$570203m1+$SP*0.3} 点伤害（受法术强度加成）$?s300512[，并使受到的伤害降低 $300512s2%][]，持续 $d。\r\n\r\n消耗你的 |cffffffff誓约|r，每消耗一层额外造成伤害。',
 `ToolTip` = '每 $t1 秒挥刀横扫，对附近敌人造成武器伤害外加 ${$570203m1+$SP*0.3} 点伤害。$?s300512[ 受到的伤害降低 $300512s2%。][]'
WHERE `ID` = 807272;

UPDATE `coa_client_spell_description` SET
 `Description` = '释放旋转的 |cffffffff破誓者|r，每 $t1 秒对附近敌人造成 $570204s2% 武器伤害外加 ${$570204m1+$SP*0.3} 点伤害（受法术强度加成）$?s300512[，并使受到的伤害降低 $300512s2%][]，持续 $d。\r\n\r\n消耗你的 |cffffffff誓约|r，每消耗一层额外造成伤害。',
 `ToolTip` = '每 $t1 秒挥刀横扫，对附近敌人造成武器伤害外加 ${$570204m1+$SP*0.3} 点伤害。$?s300512[ 受到的伤害降低 $300512s2%。][]'
WHERE `ID` = 807273;

UPDATE `coa_client_spell_description` SET
 `Description` = '释放旋转的 |cffffffff破誓者|r，每 $t1 秒对附近敌人造成 $570205s2% 武器伤害外加 ${$570205m1+$SP*0.3} 点伤害（受法术强度加成）$?s300512[，并使受到的伤害降低 $300512s2%][]，持续 $d。\r\n\r\n消耗你的 |cffffffff誓约|r，每消耗一层额外造成伤害。',
 `ToolTip` = '每 $t1 秒挥刀横扫，对附近敌人造成武器伤害外加 ${$570205m1+$SP*0.3} 点伤害。$?s300512[ 受到的伤害降低 $300512s2%。][]'
WHERE `ID` = 807274;
-- By leewheel 20261113
