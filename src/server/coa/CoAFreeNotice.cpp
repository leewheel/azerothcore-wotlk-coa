/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>
 * 免费服务器公告：每 10 分钟向所有在线玩家发送一条防倒卖提醒。
 * 目的：提醒玩家本模拟器完全免费，避免有人被第三方卖家欺骗。
 * By leewheel 2026年11月04日
 */

#include "ScriptMgr.h"
#include "WorldSessionMgr.h"
#include "World.h"

namespace
{
    // 10 分钟（毫秒）
    constexpr uint32 FREE_NOTICE_INTERVAL_MS = 10 * MINUTE * IN_MILLISECONDS;

    // 公告正文（玩家可见，必须中文）
    char const* const FREE_NOTICE_TEXT = "本模拟器完全免费，如果你通过购买获得，那么你就是上当了！";

    class CoAFreeNoticeWorldScript : public WorldScript
    {
    public:
        // 必须显式声明 ON_UPDATE 钩子，否则这个脚本不会被世界更新派发
        //By leewheel 2026年11月04日
        CoAFreeNoticeWorldScript() : WorldScript("CoAFreeNoticeWorldScript", { WORLDHOOK_ON_UPDATE }) { }
        //End By leewheel

        void OnUpdate(uint32 diff) override
        {
            _timer += diff;
            if (_timer < FREE_NOTICE_INTERVAL_MS)
                return;

            _timer = 0;

            // 记一条日志，方便核对公告确实按 10 分钟节奏发出
            LOG_INFO("server.worldserver", "免费公告已广播给所有在线玩家。");

            // 发给所有在线玩家（player 传空 = 全服广播）
            sWorldSessionMgr->SendServerMessage(SERVER_MSG_STRING, FREE_NOTICE_TEXT);
        }

    private:
        uint32 _timer = 0;
    };
}

void AddCoAFreeNoticeScripts()
{
    new CoAFreeNoticeWorldScript();
}

// End By leewheel
