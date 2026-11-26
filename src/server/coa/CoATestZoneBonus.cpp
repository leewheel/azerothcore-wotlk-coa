/* Copyright (C) 2016+ AzerothCore, GNU AGPL v3. */

#include "CoATestZoneBonus.h"
#include "Chat.h"
#include "ChatCommand.h"
#include "CommandScript.h"
#include "Config.h"
#include "DBCStores.h"
#include "DatabaseEnv.h"
#include "GameTime.h"
#include "Item.h"
#include "Log.h"
#include "Player.h"
#include "PlayerScript.h"
#include "ScriptMgr.h"
#include "StringConvert.h"
#include "Util.h"
#include "WorldScript.h"
#include <algorithm>
#include <atomic>
#include <fmt/ranges.h>
#include <limits>
#include <map>
#include <memory>
#include <mutex>
#include <tuple>
#include <vector>

using namespace Acore::ChatCommands;

namespace
{
constexpr uint32 RUNE_OF_DESCENSION = 375250;
constexpr uint32 DEFAULT_PERCENT = 200;
constexpr uint32 EXPIRY_CHECK_MS = IN_MILLISECONDS;
constexpr char ANNOUNCE_PREFIX[] = "|cffff8000[Test Zones]|r |cffffff00";
constexpr char ANNOUNCE_TEXT_COLOR[] = "|cffffff00";
constexpr char ANNOUNCE_VALUE_COLOR[] = "|cff00ccff";

struct Bonus
{
    uint32 experience = DEFAULT_PERCENT;
    uint32 runes = DEFAULT_PERCENT;
    uint32 bazaarTokens = DEFAULT_PERCENT;
    uint32 expiresAt = 0;
};

using ZoneBonuses = std::map<uint32, Bonus>;

std::mutex ZonesMutex;
std::shared_ptr<ZoneBonuses const> Configured = std::make_shared<ZoneBonuses>();
std::atomic<uint32> AnnounceIntervalMs = 15 * MINUTE * IN_MILLISECONDS;

std::shared_ptr<ZoneBonuses const> Active()
{
    std::lock_guard<std::mutex> lock(ZonesMutex);
    return Configured;
}

void Publish(ZoneBonuses zones)
{
    auto published = std::make_shared<ZoneBonuses const>(std::move(zones));
    std::lock_guard<std::mutex> lock(ZonesMutex);
    Configured = std::move(published);
}

uint32 Now()
{
    return uint32(GameTime::GetGameTime().count());
}

void LoadZones()
{
    ZoneBonuses zones;
    if (QueryResult result = WorldDatabase.Query("SELECT `zone_id`, `experience_percent`, `rune_percent`, "
            "`bazaar_token_percent`, `expires_at` FROM `coa_test_zone_bonus`"))
    {
        do
        {
            Field* fields = result->Fetch();
            zones[fields[0].Get<uint32>()] = { fields[1].Get<uint32>(), fields[2].Get<uint32>(),
                fields[3].Get<uint32>(), fields[4].Get<uint32>() };
        } while (result->NextRow());
    }
    Publish(std::move(zones));
}

uint32 PercentFor(Bonus const& bonus, TestZoneBonus::Reward reward)
{
    switch (reward)
    {
        case TestZoneBonus::Reward::Experience:
            return bonus.experience;
        case TestZoneBonus::Reward::Runes:
            return bonus.runes;
        case TestZoneBonus::Reward::BazaarTokens:
            return bonus.bazaarTokens;
    }
    return 100;
}

bool EarnsTestZoneExperience(uint8 xpSource)
{
    switch (xpSource)
    {
        case PlayerXPSource::XPSOURCE_BATTLEGROUND:
        case PlayerXPSource::XPSOURCE_PROFESSION:
        case PlayerXPSource::XPSOURCE_PROFESSION_SKILL:
            return false;
        default:
            return true;
    }
}

void GrantExtraRunes(Player* player, Item const* item, uint32 count)
{
    if (!player || !item || item->GetEntry() != RUNE_OF_DESCENSION)
        return;

    uint32 const total = TestZoneBonus::Apply(player, TestZoneBonus::Reward::Runes, count);
    if (total > count)
        player->AddItem(RUNE_OF_DESCENSION, total - count);
}

std::string ZoneName(uint32 zoneId)
{
    AreaTableEntry const* area = sAreaTableStore.LookupEntry(zoneId);
    if (!area)
        return "未知区域";

    // 中文端优先取 zhCN 区域名，缺少时回退英文
    //By leewheel 2026年11月26日
    if (!area->area_name[LOCALE_zhCN].empty())
        return area->area_name[LOCALE_zhCN];

    return area->area_name[LOCALE_enUS];
}

// 中文时长文本：secsToTimeString 输出的是英文单位，这里单独给中文
//By leewheel 2026年11月26日
std::string DurationZh(uint32 seconds)
{
    uint32 const days = seconds / DAY;
    uint32 const hours = seconds % DAY / HOUR;
    uint32 const minutes = seconds % HOUR / MINUTE;
    uint32 const secs = seconds % MINUTE;

    std::string text;
    auto append = [&text](uint32 value, char const* unit)
    {
        if (!value)
            return;
        if (!text.empty())
            text += ' ';
        text += std::to_string(value);
        text += unit;
    };

    append(days, "天");
    append(hours, "小时");
    append(minutes, "分钟");
    append(secs, "秒");

    return text.empty() ? std::string("0秒") : text;
}

std::string AnnouncedValue(std::string_view value)
{
    return Acore::StringFormat("{}{}{}", ANNOUNCE_VALUE_COLOR, value, ANNOUNCE_TEXT_COLOR);
}

std::string AnnouncedPercent(uint32 percent)
{
    return AnnouncedValue(Acore::StringFormat("{}%", percent));
}

std::string DescribeRates(Bonus const& bonus)
{
    return Acore::StringFormat("{} 经验、{} 堕落符文、{} 集市代币",
        AnnouncedPercent(bonus.experience), AnnouncedPercent(bonus.runes), AnnouncedPercent(bonus.bazaarTokens));
}

std::string TimeLeft(uint32 expiresAt)
{
    uint32 const now = Now();
    uint32 const left = expiresAt > now ? expiresAt - now : 0;
    return DurationZh(left < MINUTE ? left : (left + MINUTE - 1) / MINUTE * MINUTE);
}

std::string DescribeEnd(Bonus const& bonus)
{
    return bonus.expiresAt ? Acore::StringFormat("{} 后结束", TimeLeft(bonus.expiresAt)) : "无期限";
}

std::string AnnouncedZone(uint32 zoneId, Bonus const& bonus)
{
    if (!bonus.expiresAt)
        return ZoneName(zoneId);
    return Acore::StringFormat("{}（{} 后结束）", ZoneName(zoneId), AnnouncedValue(TimeLeft(bonus.expiresAt)));
}

std::string JoinZoneNames(std::vector<std::string>& names)
{
    std::sort(names.begin(), names.end());
    std::string text;
    for (std::size_t i = 0; i < names.size(); ++i)
    {
        if (i)
            text += i + 1 == names.size() ? " & " : ", ";
        text += names[i];
    }
    return text;
}

void AnnounceActivated(uint32 zoneId, Bonus const& bonus)
{
    std::string const ending = bonus.expiresAt
        ? Acore::StringFormat(" {} 后结束。", AnnouncedValue(TimeLeft(bonus.expiresAt))) : std::string();
    ChatHandler(nullptr).SendWorldText("{}{} 已成为测试区域：{}。帮我们找 bug，并反馈给我们！{}",
        ANNOUNCE_PREFIX, ZoneName(zoneId), DescribeRates(bonus), ending);
}

void AnnounceActiveZones()
{
    std::shared_ptr<ZoneBonuses const> const zones = Active();
    if (zones->empty())
        return;

    std::map<std::tuple<uint32, uint32, uint32>, std::vector<std::string>> zonesByRates;
    for (auto const& [zoneId, bonus] : *zones)
        zonesByRates[{ bonus.experience, bonus.runes, bonus.bazaarTokens }].push_back(AnnouncedZone(zoneId, bonus));

    std::vector<std::string> groups;
    for (auto& [rates, names] : zonesByRates)
    {
        auto const [experience, runes, bazaarTokens] = rates;
        groups.push_back(Acore::StringFormat("{}（{} 经验、{} 符文、{} 集市代币）", JoinZoneNames(names),
            AnnouncedPercent(experience), AnnouncedPercent(runes), AnnouncedPercent(bazaarTokens)));
    }

    ChatHandler(nullptr).SendWorldText("{}官方测试区域：{}。", ANNOUNCE_PREFIX, fmt::join(groups, "；"));
}

void ExpireZones()
{
    uint32 const now = Now();
    std::shared_ptr<ZoneBonuses const> const zones = Active();
    ZoneBonuses remaining;
    std::vector<uint32> expired;
    for (auto const& [zoneId, bonus] : *zones)
    {
        if (bonus.expiresAt && bonus.expiresAt <= now)
            expired.push_back(zoneId);
        else
            remaining.emplace(zoneId, bonus);
    }

    if (expired.empty())
        return;

    Publish(std::move(remaining));
    for (uint32 zoneId : expired)
    {
        WorldDatabase.Execute("DELETE FROM `coa_test_zone_bonus` WHERE `zone_id` = {}", zoneId);
        ChatHandler(nullptr).SendWorldText("{}{} 已不再是测试区域，感谢测试！",
            ANNOUNCE_PREFIX, ZoneName(zoneId));
    }
}

Optional<uint32> ParseDuration(std::string_view text)
{
    if (Optional<uint32> hours = Acore::StringTo<uint32>(text))
    {
        if (uint64(*hours) * HOUR > std::numeric_limits<uint32>::max())
            return std::nullopt;
        return *hours * HOUR;
    }

    uint32 const seconds = TimeStringToSecs(std::string(text));
    return seconds ? Optional<uint32>(seconds) : std::nullopt;
}

Optional<uint32> ResolveZone(ChatHandler* handler, Optional<uint32> zoneId)
{
    if (zoneId && *zoneId)
        return zoneId;

    if (Player* player = handler->GetPlayer())
        return player->GetZoneId();

    handler->SendErrorMessage("请在控制台指定区域编号。");
    return std::nullopt;
}
}

uint32 TestZoneBonus::Apply(Player const* player, Reward reward, uint32 amount)
{
    if (!player || !amount)
        return amount;

    std::shared_ptr<ZoneBonuses const> const zones = Active();
    auto const zone = zones->find(player->GetZoneId());
    if (zone == zones->end())
        return amount;

    uint32 const percent = PercentFor(zone->second, reward);
    uint64 const scaled = uint64(amount) * percent / 100;
    return uint32(std::min<uint64>(scaled, std::numeric_limits<uint32>::max()));
}

class CoATestZoneBonusWorld final : public WorldScript
{
public:
    CoATestZoneBonusWorld() : WorldScript("CoATestZoneBonusWorld",
        { WORLDHOOK_ON_AFTER_CONFIG_LOAD, WORLDHOOK_ON_STARTUP, WORLDHOOK_ON_UPDATE }) { }

    void OnAfterConfigLoad(bool) override
    {
        AnnounceIntervalMs = sConfigMgr->GetOption<uint32>("CoA.TestZoneBonus.AnnounceIntervalMinutes", 15)
            * MINUTE * IN_MILLISECONDS;
    }

    void OnStartup() override
    {
        LoadZones();
        LOG_INFO("server.loading", ">> Loaded {} CoA test zone bonus zones", Active()->size());
    }

    void OnUpdate(uint32 diff) override
    {
        _sinceExpiryCheck += diff;
        if (_sinceExpiryCheck >= EXPIRY_CHECK_MS)
        {
            _sinceExpiryCheck = 0;
            ExpireZones();
        }

        uint32 const interval = AnnounceIntervalMs;
        if (!interval)
            return;

        _sinceAnnounce += diff;
        if (_sinceAnnounce < interval)
            return;

        _sinceAnnounce = 0;
        AnnounceActiveZones();
    }

private:
    uint32 _sinceExpiryCheck = 0;
    uint32 _sinceAnnounce = 0;
};

class CoATestZoneBonusPlayer final : public PlayerScript
{
public:
    CoATestZoneBonusPlayer() : PlayerScript("CoATestZoneBonusPlayer",
        { PLAYERHOOK_ON_GIVE_EXP, PLAYERHOOK_ON_QUEST_REWARD_ITEM, PLAYERHOOK_ON_LOOT_ITEM }) { }

    void OnPlayerGiveXP(Player* player, uint32& amount, Unit*, uint8 xpSource) override
    {
        if (player && EarnsTestZoneExperience(xpSource) && !sScriptMgr->OnPlayerHasNoBonusExperience(player))
            amount = TestZoneBonus::Apply(player, TestZoneBonus::Reward::Experience, amount);
    }

    void OnPlayerQuestRewardItem(Player* player, Item* item, uint32 count) override
    {
        GrantExtraRunes(player, item, count);
    }

    void OnPlayerLootItem(Player* player, Item* item, uint32 count, ObjectGuid) override
    {
        GrantExtraRunes(player, item, count);
    }
};

class CoATestZoneBonusCommands final : public CommandScript
{
public:
    CoATestZoneBonusCommands() : CommandScript("CoATestZoneBonusCommands") { }

    ChatCommandTable GetCommands() const override
    {
        static ChatCommandTable testZoneTable =
        {
            { "list", HandleList, SEC_GAMEMASTER, Console::Yes },
            { "add", HandleAdd, SEC_GAMEMASTER, Console::Yes },
            { "xp", HandleExperience, SEC_GAMEMASTER, Console::Yes },
            { "runes", HandleRunes, SEC_GAMEMASTER, Console::Yes },
            { "tokens", HandleBazaarTokens, SEC_GAMEMASTER, Console::Yes },
            { "duration", HandleDuration, SEC_GAMEMASTER, Console::Yes },
            { "remove", HandleRemove, SEC_GAMEMASTER, Console::Yes },
            { "reload", HandleReload, SEC_GAMEMASTER, Console::Yes },
        };
        static ChatCommandTable commandTable =
        {
            { "testzone", testZoneTable },
        };
        return commandTable;
    }

    static bool HandleList(ChatHandler* handler)
    {
        std::shared_ptr<ZoneBonuses const> const zones = Active();
        if (zones->empty())
        {
            handler->SendSysMessage("没有测试区域：所有区域都按正常奖励发放。");
            return true;
        }

        for (auto const& [zoneId, bonus] : *zones)
            handler->PSendSysMessage("{} {}：经验 {}%，符文 {}%，集市代币 {}%，{}",
                zoneId, ZoneName(zoneId), bonus.experience, bonus.runes, bonus.bazaarTokens, DescribeEnd(bonus));
        return true;
    }

    static bool HandleAdd(ChatHandler* handler, Optional<uint32> zoneId, Optional<uint32> experience,
        Optional<uint32> runes, Optional<uint32> bazaarTokens)
    {
        return ChangeBonus(handler, zoneId, [&](Bonus& bonus)
        {
            bonus.experience = experience.value_or(DEFAULT_PERCENT);
            bonus.runes = runes.value_or(DEFAULT_PERCENT);
            bonus.bazaarTokens = bazaarTokens.value_or(DEFAULT_PERCENT);
        });
    }

    static bool HandleExperience(ChatHandler* handler, uint32 percent, Optional<uint32> zoneId)
    {
        return ChangeBonus(handler, zoneId, [percent](Bonus& bonus) { bonus.experience = percent; });
    }

    static bool HandleRunes(ChatHandler* handler, uint32 percent, Optional<uint32> zoneId)
    {
        return ChangeBonus(handler, zoneId, [percent](Bonus& bonus) { bonus.runes = percent; });
    }

    static bool HandleBazaarTokens(ChatHandler* handler, uint32 percent, Optional<uint32> zoneId)
    {
        return ChangeBonus(handler, zoneId, [percent](Bonus& bonus) { bonus.bazaarTokens = percent; });
    }

    static bool HandleDuration(ChatHandler* handler, std::string_view duration, Optional<uint32> zoneId)
    {
        Optional<uint32> const seconds = ParseDuration(duration);
        if (!seconds)
        {
            handler->SendErrorMessage("{} 不是有效时长：可直接写小时数（例如 12），也可用 90m、1d12h 这类写法；0 表示永不过期。",
                duration);
            return false;
        }

        uint32 const expiresAt = *seconds ? Now() + *seconds : 0;
        return ChangeBonus(handler, zoneId, [expiresAt](Bonus& bonus) { bonus.expiresAt = expiresAt; });
    }

    static bool HandleRemove(ChatHandler* handler, Optional<uint32> zoneId)
    {
        Optional<uint32> const zone = ResolveZone(handler, zoneId);
        if (!zone)
            return false;

        ZoneBonuses zones = *Active();
        if (!zones.erase(*zone))
        {
            handler->SendErrorMessage("{} {} 不是测试区域。", *zone, ZoneName(*zone));
            return false;
        }

        WorldDatabase.Execute("DELETE FROM `coa_test_zone_bonus` WHERE `zone_id` = {}", *zone);
        Publish(std::move(zones));

        handler->PSendSysMessage("{} {} 已恢复为正常奖励。", *zone, ZoneName(*zone));
        return true;
    }

    template<typename Change>
    static bool ChangeBonus(ChatHandler* handler, Optional<uint32> zoneId, Change change)
    {
        Optional<uint32> const zone = ResolveZone(handler, zoneId);
        if (!zone)
            return false;

        std::shared_ptr<ZoneBonuses const> const zones = Active();
        auto const current = zones->find(*zone);
        Bonus bonus = current != zones->end() ? current->second : Bonus();
        change(bonus);
        return StoreZone(handler, *zone, bonus);
    }

    static bool StoreZone(ChatHandler* handler, uint32 zone, Bonus const& bonus)
    {
        AreaTableEntry const* area = sAreaTableStore.LookupEntry(zone);
        if (!area || area->zone)
        {
            handler->SendErrorMessage("{} 不是有效的区域编号。", zone);
            return false;
        }

        WorldDatabase.Execute("REPLACE INTO `coa_test_zone_bonus` (`zone_id`, `experience_percent`, `rune_percent`, "
            "`bazaar_token_percent`, `expires_at`) VALUES ({}, {}, {}, {}, {})",
            zone, bonus.experience, bonus.runes, bonus.bazaarTokens, bonus.expiresAt);

        ZoneBonuses zones = *Active();
        zones[zone] = bonus;
        Publish(std::move(zones));
        AnnounceActivated(zone, bonus);

        handler->PSendSysMessage("{} {} 是测试区域：经验 {}%，符文 {}%，集市代币 {}%，{}",
            zone, ZoneName(zone), bonus.experience, bonus.runes, bonus.bazaarTokens, DescribeEnd(bonus));
        return true;
    }

    static bool HandleReload(ChatHandler* handler)
    {
        LoadZones();
        handler->PSendSysMessage("已重新载入 {} 个测试区域。", Active()->size());
        return true;
    }
};

void AddSC_CoATestZoneBonus()
{
    new CoATestZoneBonusWorld();
    new CoATestZoneBonusPlayer();
    new CoATestZoneBonusCommands();
}
