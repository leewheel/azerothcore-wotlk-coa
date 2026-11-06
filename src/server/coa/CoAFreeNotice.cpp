/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>
 * 免费服务器公告：每 10 分钟向所有在线玩家发送一次防倒卖提醒。
 * 🔴 公告不允许关闭：间隔写死为 10 分钟，没有任何开关或外部文本。
 * 🔴 公告正文以 XOR(0x5A) 加密字节保存，运行时解码，二进制里看不到明文，
 *    避免被人直接改成自己的广告语。改文案时用同一把钥匙重新生成下面的数组。
 * By leewheel 2026年11月06日
 */

#include "ScriptMgr.h"
#include "WorldSessionMgr.h"
#include "World.h"

#include <array>
#include <string>

namespace
{
    // 固定间隔：10 分钟，不提供配置，避免被关掉
    constexpr uint32 FREE_NOTICE_INTERVAL_MS = 10 * MINUTE * IN_MILLISECONDS;

    // 公告正文「本模拟器完全免费，如果你通过购买获得，那么你就是上当了！」的 UTF-8 字节，逐字节 XOR 0x5A
    constexpr uint8 FREE_NOTICE_KEY = 0x5A;
    constexpr std::array<uint8, 84> FREE_NOTICE_CIPHER = {
    0xBC, 0xC6, 0xF6, 0xBC, 0xF2, 0xFB, 0xBC, 0xD1, 0xC5, 0xBF, 0xC3, 0xF2,
    0xBF, 0xF4, 0xD6, 0xBF, 0xDF, 0xF2, 0xBF, 0xDF, 0xD7, 0xB2, 0xEE, 0xE3,
    0xB5, 0xE6, 0xD6, 0xBF, 0xFC, 0xD8, 0xBC, 0xC4, 0xC6, 0xBE, 0xE7, 0xFA,
    0xB3, 0xDA, 0xC0, 0xB2, 0xE5, 0xDD, 0xB2, 0xEE, 0xF7, 0xBE, 0xE3, 0xEA,
    0xB2, 0xD4, 0xED, 0xBF, 0xE4, 0xCD, 0xB5, 0xE6, 0xD6, 0xB3, 0xD8, 0xF9,
    0xBE, 0xE3, 0xD2, 0xBE, 0xE7, 0xFA, 0xBF, 0xEA, 0xEB, 0xBC, 0xC2, 0xF5,
    0xBE, 0xE2, 0xD0, 0xBF, 0xE7, 0xC9, 0xBE, 0xE0, 0xDC, 0xB5, 0xE6, 0xDB
,
    };

    class CoAFreeNoticeWorldScript : public WorldScript
    {
    public:
        // 必须显式声明钩子，否则 OnStartup / OnUpdate 不会被派发
        //By leewheel 2026年11月06日
        CoAFreeNoticeWorldScript() : WorldScript("CoAFreeNoticeWorldScript",
            { WORLDHOOK_ON_STARTUP, WORLDHOOK_ON_UPDATE }) { }
        //End By leewheel

        void OnStartup() override
        {
            _text.resize(FREE_NOTICE_CIPHER.size());
            for (std::size_t i = 0; i < FREE_NOTICE_CIPHER.size(); ++i)
                _text[i] = static_cast<char>(FREE_NOTICE_CIPHER[i] ^ FREE_NOTICE_KEY);

            LOG_INFO("server.worldserver", "免费公告已加载，每 10 分钟广播一次。");
        }

        void OnUpdate(uint32 diff) override
        {
            _timer += diff;
            if (_timer < FREE_NOTICE_INTERVAL_MS)
                return;

            _timer = 0;

            // 记一条日志，方便核对公告确实按 10 分钟节奏发出
            LOG_INFO("server.worldserver", "免费公告已广播给所有在线玩家。");

            // 发给所有在线玩家（player 传空 = 全服广播）
            sWorldSessionMgr->SendServerMessage(SERVER_MSG_STRING, _text);
        }

    private:
        uint32 _timer = 0;
        std::string _text;
    };
}

void AddCoAFreeNoticeScripts()
{
    new CoAFreeNoticeWorldScript();
}

// End By leewheel