/*
 * Copyright (С) since 2019+ AzerothCore <www.azerothcore.org>
 * Licence MIT https://opensource.org/MIT
 */

#include "Battlefield.h"
#include "BattlefieldMgr.h"
#include "Chat.h"
#include "ObjectMgr.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "CFBG.h"

using namespace Acore::ChatCommands;

class cfbg_commandscript : public CommandScript
{
public:
    cfbg_commandscript() : CommandScript("cfbg_commandscript") { }

    ChatCommandTable GetCommands() const override
    {
        static ChatCommandTable cfbgCommands =
        {
            { "race",  HandleCFBGChooseRace, SEC_PLAYER,        Console::No  },
            { "debug", HandleCFBGDebug,      SEC_MODERATOR,     Console::Yes },
        };

        static ChatCommandTable commandTable =
        {
            { "cfbg",  cfbgCommands },
        };

        return commandTable;
    }

    static bool HandleCFBGChooseRace(ChatHandler* handler, std::string raceInput)
    {
        Player* player = handler->GetPlayer();

        uint8 raceId = 0;

        if (sCFBG->RandomizeRaces() || sCFBG->KeepRace())
        {
            handler->SendSysMessage("种族选择当前已关闭。"); //By leewheel 2026年10月30日 汉化玩家可见提示
            handler->SetSentErrorMessage(true);
            return true;
        }

        for (auto const& raceVariable : *sCFBG->GetRaceInfo())
        {
            if (raceInput == raceVariable.RaceName)
            {
                if (player->GetTeamId(true) == raceVariable.TeamId)
                {
                    raceId = raceVariable.RaceId;
                }
                else
                {
                    handler->SendSysMessage("该种族不适用于你的阵营。"); //By leewheel 2026年10月30日
                    handler->SetSentErrorMessage(true);
                    return true;
                }

                if (!IsRaceValidForClass(player, raceId))
                {
                    handler->SendSysMessage("该种族不适用于你的职业。"); //By leewheel 2026年10月30日
                    handler->SetSentErrorMessage(true);
                    return true;
                }

                if (raceId == RACE_NIGHTELF)
                {
                    handler->SendSysMessage("暗夜精灵模型不可用：女性模型缺失，男性模型会导致客户端崩溃。"); //By leewheel 2026年10月30日
                    handler->SetSentErrorMessage(true);
                    return true;
                }

                if (player->getGender() == GENDER_FEMALE && (raceId == RACE_TROLL || raceId == RACE_DWARF))
                {
                    handler->SendSysMessage("以下种族没有可用的女性模型：巨魔、矮人。"); //By leewheel 2026年10月30日
                    handler->SetSentErrorMessage(true);
                    return true;
                }
            }
        }

        player->UpdatePlayerSetting("mod-cfbg", SETTING_CFBG_RACE, raceId);

        if (!raceId)
        {
            handler->SendSysMessage("该种族不可用。跨阵营战场种族已设为随机：当你以对立阵营身份进入战场时，会被随机变形为一个种族。"); //By leewheel 2026年10月30日
        }
        else
        {
            handler->PSendSysMessage("跨阵营战场种族已设为 {}", raceInput); //By leewheel 2026年10月30日
        }

        return true;
    }

    // 调试面板阵营名，输出给 GM 看，直接出中文
    //By leewheel 2026年11月26日
    static char const* TeamIdName(TeamId t)
    {
        switch (t)
        {
            case TEAM_ALLIANCE: return "联盟";
            case TEAM_HORDE:    return "部落";
            default:            return "中立";
        }
    }

    static char const* YesNo(bool v) { return v ? "是" : "否"; }
    static char const* MarkYN(bool v) { return v ? "Y" : "-"; }

    static bool HandleCFBGDebug(ChatHandler* handler, Optional<PlayerIdentifier> player)
    {
        if (!player)
            player = PlayerIdentifier::FromTargetOrSelf(handler);

        if (!player || !player->IsConnected())
        {
            handler->SendErrorMessage(LANG_PLAYER_NOT_FOUND);
            return false;
        }

        Player* target = player->GetConnectedPlayer();
        ObjectGuid const guid = target->GetGUID();

        bool const isFake     = sCFBG->IsPlayerFake(target);
        bool const native     = sCFBG->IsPlayingNative(target);
        bool const forgetBG   = sCFBG->ShouldForgetBGPlayers(target);
        bool const inBG       = target->InBattleground();
        uint8 const preferredRace = target->GetPlayerSetting("mod-cfbg", SETTING_CFBG_RACE).value;
        FakePlayer const* fake = sCFBG->GetFakePlayer(target);

        // === 标题 ===
        //By leewheel 2026年11月26日
        handler->PSendSysMessage("=== 跨阵营战场调试：{} ===", target->GetName());
        handler->PSendSysMessage("  GUID：{}", guid.ToString());
        handler->PSendSysMessage("  配置：  系统={}  冬拥湖={}",
            YesNo(sCFBG->IsEnableSystem()), YesNo(sCFBG->IsEnableWGSystem()));

        // === 阵营 / 外观 ===
        handler->SendSysMessage(" ");
        handler->SendSysMessage("  阵营");
        handler->PSendSysMessage("    原生       {:<8}  （种族 {}）",
            TeamIdName(target->GetTeamId(true)), uint32(target->getRace(true)));
        handler->PSendSysMessage("    当前       {:<8}  （种族 {}）",
            TeamIdName(target->GetTeamId()), uint32(target->getRace()));
        handler->PSendSysMessage("    战场阵营   {}", TeamIdName(target->GetBgTeamId()));
        handler->PSendSysMessage("    外观编号   {}（当前）/ {}（原生）",
            target->GetDisplayId(), target->GetNativeDisplayId());

        // === 跨阵营战场状态 ===
        handler->SendSysMessage(" ");
        handler->SendSysMessage("  状态");
        handler->PSendSysMessage("    已伪装             {}", YesNo(isFake));
        handler->PSendSysMessage("    按原生运行         {}", YesNo(native));
        handler->PSendSysMessage("    在战场内           {}", YesNo(inBG));
        handler->PSendSysMessage("    职业 / 性别        {} / {}",
            uint32(target->getClass()), uint32(target->getGender()));
        handler->PSendSysMessage("    首选种族           {}", uint32(preferredRace));
        handler->PSendSysMessage("    遗忘战场玩家       {}", YesNo(forgetBG));

        // === 伪装记录 ===
        if (fake)
        {
            handler->SendSysMessage(" ");
            handler->SendSysMessage("  伪装记录");
            handler->PSendSysMessage("    伪装  阵营={:<8}  种族={}  变形={}",
                TeamIdName(fake->FakeTeamID), uint32(fake->FakeRace), fake->FakeMorph);
            handler->PSendSysMessage("    真实  阵营={:<8}  种族={}  变形={}  原生变形={}",
                TeamIdName(fake->RealTeamID), uint32(fake->RealRace),
                fake->RealMorph, fake->RealNativeMorph);
        }

        // === Wintergrasp ===
        uint32 const zoneId = target->GetZoneId();
        Battlefield* bf = sBattlefieldMgr->GetBattlefieldToZoneId(zoneId);
        bool const inWGZone = bf && bf->GetTypeId() == BATTLEFIELD_WG;

        // Look up the WG battlefield even when the player is elsewhere, so we
        // can still flag stale fakes outside the zone. 4197 is Wintergrasp.
        Battlefield* wg = inWGZone ? bf : nullptr;
        if (!wg)
            if (Battlefield* candidate = sBattlefieldMgr->GetBattlefieldToZoneId(4197))
                if (candidate->GetTypeId() == BATTLEFIELD_WG)
                    wg = candidate;

        handler->SendSysMessage(" ");
        handler->SendSysMessage("  冬拥湖");
        handler->PSendSysMessage("    在冬拥湖区域 {}（区域 {}）", YesNo(inWGZone), zoneId);

        if (!wg)
        {
            handler->SendSysMessage("    战时状态     不适用（无冬拥湖战场）");
        }
        else
        {
            handler->PSendSysMessage("    战时状态     {}", YesNo(wg->IsWarTime()));

            bool const inQueueA = wg->GetPlayersQueueSet(TEAM_ALLIANCE).count(guid) > 0;
            bool const inQueueH = wg->GetPlayersQueueSet(TEAM_HORDE).count(guid)    > 0;
            bool const invitedA = wg->GetInvitedPlayersMap(TEAM_ALLIANCE).count(guid) > 0;
            bool const invitedH = wg->GetInvitedPlayersMap(TEAM_HORDE).count(guid)    > 0;
            bool const inWarA   = wg->GetPlayersInWarSet(TEAM_ALLIANCE).count(guid)   > 0;
            bool const inWarH   = wg->GetPlayersInWarSet(TEAM_HORDE).count(guid)      > 0;

            handler->SendSysMessage("    玩家集合状态：");
            handler->PSendSysMessage("                   联盟    部落");
            handler->PSendSysMessage("      排队            {}       {}", MarkYN(inQueueA), MarkYN(inQueueH));
            handler->PSendSysMessage("      受邀            {}       {}", MarkYN(invitedA), MarkYN(invitedH));
            handler->PSendSysMessage("      参战            {}       {}", MarkYN(inWarA),   MarkYN(inWarH));

            // Which side does core track this player on, if any?
            bool const onA = inWarA || invitedA || inQueueA;
            bool const onH = inWarH || invitedH || inQueueH;
            std::optional<TeamId> coreTeam;
            if (onA) coreTeam = TEAM_ALLIANCE;
            if (onH) coreTeam = TEAM_HORDE;
            bool const inBothSides = onA && onH;

            // ---- 异常扫描 ----
            //By leewheel 2026年11月26日
            std::vector<std::string> issues;

            if (inBothSides)
                issues.emplace_back("同时被联盟与部落冬拥湖集合追踪（集合泄漏）");

            if (fake && fake->FakeTeamID == fake->RealTeamID)
                issues.emplace_back(Acore::StringFormat(
                    "过期伪装记录：伪装阵营 == 真实阵营（{}）",
                    TeamIdName(fake->FakeTeamID)));

            if (coreTeam && !inBothSides && target->GetTeamId() != *coreTeam)
                issues.emplace_back(Acore::StringFormat(
                    "当前阵营（{}）与核心记录的冬拥湖侧（{}）不一致",
                    TeamIdName(target->GetTeamId()), TeamIdName(*coreTeam)));

            if (fake && coreTeam && !inBothSides && fake->FakeTeamID != *coreTeam)
                issues.emplace_back(Acore::StringFormat(
                    "伪装阵营（{}）与核心记录的冬拥湖侧（{}）不一致",
                    TeamIdName(fake->FakeTeamID), TeamIdName(*coreTeam)));

            if (isFake && fake)
            {
                bool const inRealWarSet = (fake->RealTeamID == TEAM_ALLIANCE) ? inWarA : inWarH;
                bool const inFakeWarSet = (fake->FakeTeamID == TEAM_ALLIANCE) ? inWarA : inWarH;
                if (inRealWarSet && !inFakeWarSet && fake->FakeTeamID != fake->RealTeamID)
                    issues.emplace_back(Acore::StringFormat(
                        "已伪装成{}，却停留在核心{}的参战集合（战场组不同步）",
                        TeamIdName(fake->FakeTeamID), TeamIdName(fake->RealTeamID)));
            }

            if (inWGZone && wg->IsWarTime() && isFake && !inWarA && !inWarH && !invitedA && !invitedH)
                issues.emplace_back("战时在冬拥湖区域内被伪装，但不在参战/受邀集合中");

            if (isFake && !inWGZone && !inBG)
                issues.emplace_back("在冬拥湖区域外、且不在战场中仍处伪装状态（清理泄漏）");

            if (inWGZone && isFake && !sCFBG->IsEnableWGSystem())
                issues.emplace_back("在冬拥湖区域内被伪装，但 CFBG.Battlefield.Enable=0");

            handler->SendSysMessage(" ");
            if (issues.empty())
            {
                handler->SendSysMessage("  异常：无");
            }
            else
            {
                handler->PSendSysMessage("  异常（{} 项）：", uint32(issues.size()));
                for (std::string const& msg : issues)
                    handler->PSendSysMessage("    ! {}", msg);
            }
        }

        return true;
    }

    static bool IsRaceValidForClass(Player* player, uint8 fakeRace)
    {
        RaceData const& raceData = sCFBG->GetRaceDataForClass(player->getClass());

        std::vector<uint8> const& availableRacesForClass = player->GetTeamId(true) == TEAM_HORDE ?
            raceData.availableRacesA : raceData.availableRacesH;

        for (auto const& races : availableRacesForClass)
        {
            if (races == fakeRace)
            {
                return true;
            }
        }

        return false;
    }
};

void AddSC_cfbg_commandscript()
{
    new cfbg_commandscript();
}

class cfbg_bf_commandscript : public CommandScript
{
public:
    cfbg_bf_commandscript() : CommandScript("cfbg_bf_commandscript") { }

    ChatCommandTable GetCommands() const override
    {
        static ChatCommandTable bfSubCommands =
        {
            { "list", HandleBFList, SEC_ADMINISTRATOR, Console::No },
        };

        static ChatCommandTable commandTable =
        {
            { "bf", bfSubCommands },
        };

        return commandTable;
    }

    static bool HandleBFList(ChatHandler* handler, uint32 battleId)
    {
        Battlefield* bf = sBattlefieldMgr->GetBattlefieldByBattleId(battleId);

        if (!bf)
        {
            handler->SendErrorMessage("找不到战场 {}。", battleId);
            return false;
        }

        uint32 const allianceZone = bf->GetPlayersInZoneCount(TEAM_ALLIANCE);
        uint32 const hordeZone    = bf->GetPlayersInZoneCount(TEAM_HORDE);
        uint32 const allianceWar  = bf->GetPlayersInWarCount(TEAM_ALLIANCE);
        uint32 const hordeWar     = bf->GetPlayersInWarCount(TEAM_HORDE);
        uint32 const maxPerTeam   = bf->GetMaxPlayersPerTeam();

        //By leewheel 2026年11月26日
        handler->SendSysMessage(Acore::StringFormat("战场 {} | {}", battleId,
            bf->IsWarTime() ? "战争中" : "和平").c_str());
        handler->SendSysMessage(Acore::StringFormat("  联盟：区域内 {} 人，参战 {} 人 / 上限 {}",
            allianceZone, allianceWar, maxPerTeam).c_str());
        handler->SendSysMessage(Acore::StringFormat("  部落：区域内 {} 人，参战 {} 人 / 上限 {}",
            hordeZone, hordeWar, maxPerTeam).c_str());

        return true;
    }
};

void AddSC_cfbg_bf_commandscript()
{
    new cfbg_bf_commandscript();
}
