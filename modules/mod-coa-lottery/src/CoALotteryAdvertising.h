#ifndef COA_LOTTERY_ADVERTISING_H
#define COA_LOTTERY_ADVERTISING_H

#include "ObjectMgr.h"
#include "StringFormat.h"

#include <algorithm>
#include <array>
#include <cstdint>
#include <string>
#include <string_view>

namespace CoALottery
{
    // 广告文案已迁入 module_string 表（module = "mod-coa-lottery"），//By leewheel 2026年10月27日
    // id 29-47 十九条固定喊话、48 金币、49-54 时间单位、55 兜底称呼、56/57 城市名。
    constexpr char const* AdModule = "mod-coa-lottery";

    /// 按语言取一条 module_string；缺行时核心记日志并返回 "error"。
    inline std::string AdStr(uint32_t id, LocaleConstant locale)
    {
        std::string const* str = sObjectMgr->GetModuleString(AdModule, id, locale);
        return str ? *str : "error";
    }

    constexpr uint32_t GallywixMap = 0;
    constexpr float GallywixX = -8787.7705f;
    constexpr float GallywixY = 640.43396f;
    constexpr float GallywixZ = 96.12781f;
    constexpr float GoldilocksX = -8788.967f;
    constexpr float GoldilocksY = 643.0418f;
    constexpr float GoldilocksZ = 94.944855f;

    struct LotteryLocation
    {
        uint32_t map;
        float gallywixX, gallywixY, gallywixZ;
        float goldilocksX, goldilocksY, goldilocksZ;
        float orientation;
    };

    constexpr LotteryLocation StormwindLotteryLocation =
        { GallywixMap, GallywixX, GallywixY, GallywixZ, GoldilocksX, GoldilocksY, GoldilocksZ, 3.14159265f };
    constexpr LotteryLocation OrgrimmarLotteryLocation =
        { 1, 1621.1122f, -4419.4966f, 14.876221f, 1623.0135f, -4417.805f, 14.7874975f, 4.71238898f };

    inline float GoldilocksScale(uint32_t duration, uint64_t remaining)
    {
        if (!duration)
            return 0.5f;
        return 1.5f - float(std::min<uint64_t>(remaining, duration)) / float(duration);
    }

    constexpr auto AdvertisementLines = std::to_array<std::string_view>({
        "{city}! Gallywix's lottery jackpot is up to {pot}! Goldilocks has your ticket to the big time!",
        "{player}, you look like someone with expensive tastes! Ten gold for a ticket. Give Goldilocks a visit!",
        "Only {time} until the draw! Stop counting your coppers and start dreaming about {pot}!",
        "Tired of splitting loot with four other cheapskates? The winning ticket takes the entire pot!",
        "The jackpot is {pot}, pal! That's a lot of repairs, mounts, and other questionable financial decisions!",
        "Time is money, and you've got {time} left! Get your golden tickets from Goldilocks!",
        "Rigged?! No, but of course I've got a feeeew house tickets... Same odds as yours... Read the rules!",
        "{player}, your next big adventure could start at the mailbox! Winners get their gold mailed straight to them and I pay for postage out of sheer generosity!",
        "The draw is in {time}! Buy more tickets for more chances. No guarantees and certainly no refunds!",
        "Gallywix's lottery! {pot} in the pot! Goldilocks sells the tickets whilst I provide the entrepreneurial genius!",
        "Someone wins? We mail the prize! I win on a house ticket? The pot gets destroyed! Nobody can say I hid the rules!",
        "{player}, got ten gold and a dream? Talk to Goldilocks!",
        "{time} left, {pot} at stake! Remember: a golden ticket buys a chance, not a guarantee!",
        "It's demotions for everyone if the Sharks beat the Buccaneers or if this lottery does not reach gold cap!",
        "Thank you for your hard work and dedication in fighting Azeroth's inflation. Unpaid overtime is approved for all!",
        "Is that you, {player}? Have you signed up for this week's raffle?",
        "You're all lazy! Get back to work. Especially you, {player}!",
        "What's this I hear about a party? I wasn't invited!",
        "All hail the greatest trade prince on Azeroth... me!"
    }); // 英文原文仅作 token 结构参考；实际文案按 locale 从 module_string(id 29-47) 取 //By leewheel 2026年10月27日

    inline std::string AdvertisementTime(uint64_t remaining, LocaleConstant locale)
    {
        uint64_t amount;
        uint32_t unitId;
        if (remaining > 86400)
        {
            amount = remaining / 86400;
            unitId = amount == 1 ? 49 : 50; // day / days
        }
        else if (remaining > 3600)
        {
            amount = remaining / 3600;
            unitId = amount == 1 ? 51 : 52; // hour / hours
        }
        else
        {
            amount = remaining ? std::max<uint64_t>(1, remaining / 60) : 0;
            unitId = amount == 1 ? 53 : 54; // minute / minutes
        }
        return std::to_string(amount) + " " + AdStr(unitId, locale);
    }

    /// cityId: 56 = Stormwind, 57 = Orgrimmar（module_string 城市名）。
    inline std::string BuildAdvertisement(uint32_t index, uint32_t copper, uint64_t remaining,
        std::string_view playerName, uint32_t cityId = 56, LocaleConstant locale = LOCALE_enUS)
    {
        std::string message = AdStr(29 + index % 19, locale);
        std::string pot = Acore::StringFormat(AdStr(48, locale), copper / 10000);
        std::string time = AdvertisementTime(remaining, locale);
        auto replace = [&message](std::string_view token, std::string_view value)
        {
            size_t position = 0;
            while ((position = message.find(token, position)) != std::string::npos)
            {
                message.replace(position, token.size(), value);
                position += value.size();
            }
        };
        replace("{city}", AdStr(cityId, locale));
        replace("{pot}", pot);
        replace("{time}", time);
        replace("{player}", playerName.empty() ? AdStr(55, locale) : playerName);
        return message;
    }
}

#endif
