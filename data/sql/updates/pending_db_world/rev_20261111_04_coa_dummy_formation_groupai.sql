-- By leewheel 2026年11月11日
-- 上游 rev_20261110_dynamic_training_dummies.sql 的 creature_formations 段只写了 leaderGUID/memberGUID，
-- groupAI 落到默认值 0，核心判定「成员行必须有受支持的 GroupAI 标志位」，
-- 于是启动时报 20 条：
--   creature_formations table leader guid X and member guid Y has unsupported GroupAI flag value (0). Skipped
-- 后果不只是日志噪音：假人脚本靠 me->GetFormation() 让「点一个假人整组进入训练」，
-- 成员行被 Skip 后编队不成立，这个功能直接失效。
-- 这里把 4 个编队的成员行补成 3（MEMBER_ASSIST_LEADER | LEADER_ASSIST_MEMBER），
-- 与库内 3331 条主流编队一致；距离/角度保持 0（假人是固定站桩，不跟随移动）。
-- 队长行保持 0 —— 核心明确允许 leader 不带标志位。
UPDATE `creature_formations`
SET `groupAI` = 3
WHERE `leaderGUID` IN (9013508, 9013515, 9074103, 9074109)
  AND `memberGUID` <> `leaderGUID`;

-- End By leewheel
