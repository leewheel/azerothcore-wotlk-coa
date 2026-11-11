/*
 * This file is part of the AzerothCore Project. See AUTHORS file for Copyright information
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

//By leewheel 2026年11月8日
// 招募战友系统玩家可见文本全量汉化：邀请校验失败提示、动态弹出的邀请窗口文案与选项、
// 接受/拒绝反馈、保存失败提示、.raf levels / .raf status / .raf rewards / .raf claim 的输出。
// 协议串（.raf 子命令名、日志与错误码）保持英文不变。
//End By leewheel

#include "Chat.h"
#include "Config.h"
#include "CryptoRandom.h"
#include "DatabaseEnv.h"
#include "IpAddress.h"
#include "Item.h"
#include "Mail.h"
#include "Realm.h"
#include "StringConvert.h"
#include "StringFormat.h"
#include "Tokenize.h"
#include "World.h"
#include <algorithm>
#include <memory>
#include <optional>
#include <unordered_map>
#include <vector>
#include "GameTime.h"
#include "Map.h"
#include "ObjectMgr.h"
#include "Opcodes.h"
#include "Player.h"
#include "PlayerSettings.h"
#include "ScriptMgr.h"
#include "SocialMgr.h"
#include "WorldSession.h"
#include "WorldSessionMgr.h"

namespace
{
    constexpr uint32 RecruitAFriendMenu = 0x524146;
    constexpr uint32 AcceptRecruitment = 1;
    constexpr uint32 DeclineRecruitment = 2;
    constexpr time_t ProposalLifetime = 60;
    constexpr time_t LinkedRewardInterval = 60;
    constexpr time_t UnlinkedRecoveryInterval = 15 * 60;
    constexpr uint32 RewardSpread = 17;

    uint8 GrantLevelError(Player* donor, Player* target)
    {
        if (!target || target == donor)
            return ERR_REFER_A_FRIEND_NO_TARGET;
        if (PlayerSettingVector const* prestige = target->FindPlayerSettings("core.coa_prestige");
            prestige && prestige->size() > 1 && (*prestige)[1].value != 0)
            return ERR_REFER_A_FRIEND_NOT_NOW;
        if (!donor->GetGrantableLevels())
            return ERR_REFER_A_FRIEND_INSUFFICIENT_GRANTABLE_LEVELS;
        if (donor->GetSession()->GetAccountId() == target->GetSession()->GetAccountId() ||
            (donor->GetSession()->GetRecruiterId() != target->GetSession()->GetAccountId() &&
                target->GetSession()->GetRecruiterId() != donor->GetSession()->GetAccountId()))
            return ERR_REFER_A_FRIEND_NOT_REFERRED_BY;
        if (target->GetLevel() >= donor->GetLevel())
            return ERR_REFER_A_FRIEND_TARGET_TOO_HIGH;
        if (target->GetLevel() >= sWorld->getIntConfig(CONFIG_MAX_RECRUIT_A_FRIEND_BONUS_PLAYER_LEVEL) ||
            target->GetLevel() >= target->GetUInt32Value(PLAYER_FIELD_MAX_LEVEL))
            return ERR_REFER_A_FRIEND_GRANT_LEVEL_MAX_I;
        if (!donor->GetGroup() || donor->GetGroup() != target->GetGroup())
            return ERR_REFER_A_FRIEND_NOT_IN_GROUP;
        if (!donor->IsInMap(target) || !donor->IsAtRecruitAFriendDistance(target))
            return ERR_REFER_A_FRIEND_TOO_FAR;
        if (!donor->IsAlive() || !target->IsAlive() || donor->IsInCombat() || target->IsInCombat() ||
            donor->IsBeingTeleported() || target->IsBeingTeleported() || donor->IsInFlight() || target->IsInFlight())
            return ERR_REFER_A_FRIEND_NOT_NOW;
        if (uint8 cap = sScriptMgr->GetMaxAllowedLevel(target))
            if (target->GetLevel() >= cap)
                return ERR_REFER_A_FRIEND_NOT_NOW;
        return ERR_REFER_A_FRIEND_NONE;
    }

    void SendGrantError(WorldSession* session, uint8 error, Player const* target)
    {
        WorldPacket data(SMSG_REFER_A_FRIEND_FAILURE, 24);
        data << uint32(error);
        if (error == ERR_REFER_A_FRIEND_NOT_IN_GROUP && target)
            data << target->GetName();
        session->SendPacket(&data);
    }
}

void WorldSession::HandleGrantLevel(WorldPacket& recvData)
{
    ObjectGuid guid;
    recvData >> guid.ReadAsPacked();
    Player* target = ObjectAccessor::GetPlayer(*_player, guid);
    if (uint8 error = GrantLevelError(_player, target))
    {
        SendGrantError(this, error, target);
        return;
    }

    WorldSession* recipient = target->GetSession();
    if (recipient->_rafGrantExpiry > GameTime::GetGameTime().count())
    {
        SendGrantError(this, ERR_REFER_A_FRIEND_NOT_NOW, target);
        return;
    }
    recipient->_rafGrantFrom = _player->GetGUID();
    recipient->_rafGrantRecipient = target->GetGUID();
    recipient->_rafGrantLevel = target->GetLevel();
    recipient->_rafGrantDonorLevel = _player->GetLevel();
    recipient->_rafGrantExpiry = GameTime::GetGameTime().count() + ProposalLifetime;
    WorldPacket data(SMSG_PROPOSE_LEVEL_GRANT, 8);
    data << _player->GetPackGUID();
    target->SendDirectMessage(&data);
}

void WorldSession::HandleAcceptGrantLevel(WorldPacket& recvData)
{
    ObjectGuid guid;
    recvData >> guid.ReadAsPacked();
    if (guid != _rafGrantFrom || _rafGrantRecipient != _player->GetGUID())
        return;

    time_t const expiry = _rafGrantExpiry;
    _rafGrantExpiry = 0;
    _rafGrantFrom.Clear();
    _rafGrantRecipient.Clear();
    if (expiry <= GameTime::GetGameTime().count())
        return;

    Player* donor = ObjectAccessor::GetPlayer(*_player, guid);
    if (!donor || donor->GetLevel() != _rafGrantDonorLevel || _player->GetLevel() != _rafGrantLevel)
        return;
    if (uint8 error = GrantLevelError(donor, _player))
    {
        SendGrantError(donor->GetSession(), error, _player);
        return;
    }

    uint8 const nextLevel = _player->GetLevel() + 1;
    _player->GiveLevel(nextLevel);
    if (_player->GetLevel() != nextLevel)
    {
        SendGrantError(donor->GetSession(), ERR_REFER_A_FRIEND_NOT_NOW, _player);
        return;
    }

    donor->SetGrantableLevels(donor->GetGrantableLevels() - 1);
    CharacterDatabaseTransaction trans = CharacterDatabase.BeginTransaction();
    _player->SaveToDB(trans, false, false);
    donor->SaveToDB(trans, false, false);
    CharacterDatabase.CommitTransaction(trans);
}

void WorldSession::ClearRecruitAFriendRequests()
{
    _rafGrantFrom.Clear();
    _rafGrantRecipient.Clear();
    _rafGrantExpiry = 0;
    _rafInviter.Clear();
    _rafInviteExpiry = 0;
    _rafSummoner.Clear();
}

void WorldSession::RefreshRecruitAFriendFlags()
{
    if (!_player || !_player->IsInWorld())
        return;
    if (isRecruiter || recruiterId)
        _player->SetDynamicFlag(UNIT_DYNFLAG_REFER_A_FRIEND);
    _player->SetRestBonus(_player->GetRestBonus());
    _player->SetGrantableLevels(_player->GetGrantableLevels());
    _player->GetSocial()->SendSocialList(_player, SOCIAL_FLAG_FRIEND);
}

namespace
{
    std::optional<std::string> RecruitmentAddress(WorldSession& session)
    {
        boost::system::error_code error;
        auto const address = Acore::Net::make_address(session.GetRemoteAddress(), error);
        if (error || address.is_unspecified())
            return std::nullopt;
        auto const normalized = address.is_v4()
            ? boost::asio::ip::make_address_v6(boost::asio::ip::v4_mapped, address.to_v4())
            : address.to_v6();
        if (normalized.is_v4_mapped() &&
            boost::asio::ip::make_address_v4(boost::asio::ip::v4_mapped, normalized).is_unspecified())
            return std::nullopt;
        return normalized.to_string();
    }

    struct RecruitmentAddresses
    {
        bool valid = false;
        std::optional<std::string> shared;
    };

    RecruitmentAddresses LinkRecruitmentAddresses(WorldSession& inviter, WorldSession& recipient)
    {
        auto const inviterAddress = RecruitmentAddress(inviter);
        auto const recipientAddress = RecruitmentAddress(recipient);
        if (!inviterAddress || !recipientAddress)
            return {};
        if (*inviterAddress == *recipientAddress)
            return { true, inviterAddress };
        return { true, std::nullopt };
    }

    uint32 SharedAddressLinkLimit()
    {
        return sWorld->getIntConfig(CONFIG_RECRUIT_A_FRIEND_SHARED_ADDRESS_LINKS);
    }

    bool SharedAddressHasFreeLink(std::string const& address)
    {
        auto* links = LoginDatabase.GetPreparedStatement(LOGIN_SEL_RAF_SHARED_ADDRESS_LINKS);
        links->SetData(0, address);
        PreparedQueryResult const result = LoginDatabase.Query(links);
        return result && result->Fetch()[0].Get<uint64>() < SharedAddressLinkLimit();
    }

    void SetSharedAddress(LoginDatabasePreparedStatement* stmt, uint8 index, std::optional<std::string> const& address)
    {
        if (address)
            stmt->SetData(index, *address);
        else
            stmt->SetData(index, nullptr);
    }

    //By leewheel 2026年11月12日 玩家可见提示中文化
    constexpr char const* InvalidAddressRefusal = "招募战友需要双方都是有效的 IP 地址。";
    constexpr char const* SharedAddressRefusal = "招募战友需要双方使用不同的 IP 地址。";
    //End By leewheel
}

bool WorldSession::InviteRecruitAFriend(Player* target)
{
    ChatHandler chat(this);
    auto reject = [&chat](char const* message)
    {
        chat.SendSysMessage(message);
        return false;
    };
    time_t const now = GameTime::GetGameTime().count();
    if (!_player)
        return reject("招募战友需要先登录到游戏世界中的角色。");
    if (!target)
        return reject("该角色不在本服在线。请使用 .raf <角色名>。");
    if (target == _player || target->GetSession()->GetAccountId() == GetAccountId())
        return reject("你不能招募自己或同账号下的其他角色。");

    WorldSession* recipient = target->GetSession();
    //By leewheel 2026年11月12日 合并上游 #11823：改用 LinkRecruitmentAddresses（同 IP 允许两条招募）
    RecruitmentAddresses const addresses = LinkRecruitmentAddresses(*this, *recipient);
    if (!addresses.valid)
        return reject(InvalidAddressRefusal);
    if (addresses.shared && !SharedAddressLinkLimit())
        return reject(SharedAddressRefusal);
    //End By leewheel
    if (recipient->recruiterId == GetAccountId())
        return reject("该账号已被你招募。招募关系永久有效；可用 .raf status 查看你的被招募者。");
    if (recipient->recruiterId)
        return reject("该账号已有其他招募者，现有招募关系无法更改。");
    if (recruiterId == recipient->GetAccountId())
        return reject("该账号是你的招募者，招募对方会形成循环关系。");
    if (!_player->IsAlive() || !target->IsAlive())
        return reject("发送招募邀请前，双方角色都必须存活。");
    if (_player->IsInCombat() || target->IsInCombat())
        return reject("发送招募邀请前，双方角色都必须脱离战斗。");
    if (_player->IsBeingTeleported() || target->IsBeingTeleported())
        return reject("请等双方传送完成后再发送邀请。");
    if (recipient->_rafInviteExpiry > now)
    {
        if (recipient->_rafInviter == _player->GetGUID())
            return reject("你已经邀请过该角色。对方需要接受或拒绝；邀请 60 秒后过期。");
        return reject("该角色已有一条待处理的招募邀请，请等对方答复或邀请过期后再试。");
    }
    if (_rafInviteCooldown > now)
    {
        chat.PSendSysMessage("请等待 {} 秒后再发送招募邀请。",
            uint32(_rafInviteCooldown - now));
        return false;
    }
    _rafInviteCooldown = now + 10;
    if (addresses.shared && !SharedAddressHasFreeLink(*addresses.shared))
    {
        //By leewheel 2026年11月12日 中文化
        chat.PSendSysMessage("同一 IP 地址最多允许 {} 条招募绑定，该 IP 已达上限。",
            SharedAddressLinkLimit());
        //End By leewheel
        return false;
    }
    recipient->_rafInviter = _player->GetGUID();
    recipient->_rafInviteExpiry = now + ProposalLifetime;
    target->PlayerTalkClass->ClearMenus();
    GossipMenu& menu = target->PlayerTalkClass->GetGossipMenu();
    menu.SetMenuId(RecruitAFriendMenu);
    menu.AddMenuItem(-1, GOSSIP_ICON_CHAT, "接受永久招募", 0, AcceptRecruitment, "", 0);
    menu.AddMenuItem(-1, GOSSIP_ICON_CHAT, "拒绝", 0, DeclineRecruitment, "", 0);
    target->PlayerTalkClass->SendDynamicGossipMenu(_player->GetName() +
        " 邀请你加入「招募战友」。接受后将把你的账号与其账号永久绑定，该绑定不会过期。",
        target->GetGUID());
    ChatHandler(this).SendSysMessage("招募邀请已发送，需对方接受。");
    return true;
}

bool WorldSession::HandleRecruitAFriendInviteResponse(uint32 menuId, uint32 action)
{
    if (menuId != RecruitAFriendMenu)
        return false;
    ObjectGuid const inviterGuid = _rafInviter;
    time_t const expiry = _rafInviteExpiry;
    _rafInviter.Clear();
    _rafInviteExpiry = 0;
    _player->PlayerTalkClass->SendCloseGossip();
    if (expiry <= GameTime::GetGameTime().count() || inviterGuid.IsEmpty())
        return true;
    Player* inviter = ObjectAccessor::FindPlayer(inviterGuid);
    if (!inviter)
        return true;
    if (action == DeclineRecruitment)
    {
        ChatHandler(inviter->GetSession()).SendSysMessage("招募邀请已被拒绝。");
        return true;
    }
    if (action != AcceptRecruitment || recruiterId ||
        GetAccountId() == inviter->GetSession()->GetAccountId() ||
        !_player->IsAlive() || !inviter->IsAlive() ||
        _player->IsInCombat() || inviter->IsInCombat())
        return true;

    RecruitmentAddresses const addresses = LinkRecruitmentAddresses(*inviter->GetSession(), *this);
    if (!addresses.valid || (addresses.shared && !SharedAddressLinkLimit()))
    {
        ChatHandler(this).SendSysMessage(addresses.valid ? SharedAddressRefusal : InvalidAddressRefusal);
        return true;
    }

    uint32 const inviterAccount = inviter->GetSession()->GetAccountId();
    auto* stmt = LoginDatabase.GetPreparedStatement(LOGIN_UPD_RAF_RECRUITER);
    stmt->SetData(0, inviterAccount);
    stmt->SetData(1, GetAccountId());
    SetSharedAddress(stmt, 2, addresses.shared);
    stmt->SetData(3, inviterAccount);
    stmt->SetData(4, GetAccountId());
    SetSharedAddress(stmt, 5, addresses.shared);
    stmt->SetData(6, SharedAddressLinkLimit());
    LoginDatabaseTransaction trans = LoginDatabase.BeginTransaction();
    trans->Append(LoginDatabase.GetPreparedStatement(LOGIN_INS_RAF_LINK_LOCK));
    trans->Append(LoginDatabase.GetPreparedStatement(LOGIN_UPD_RAF_LINK_LOCK));
    trans->Append(stmt);
    auto* registration = LoginDatabase.GetPreparedStatement(LOGIN_INS_RAF_LINKED_ACCOUNT);
    SetSharedAddress(registration, 0, addresses.shared);
    registration->SetData(1, GetAccountId());
    registration->SetData(2, inviterAccount);
    trans->Append(registration);
    bool const sharesAddress = addresses.shared.has_value();
    AddTransactionCallback(LoginDatabase.AsyncCommitTransaction(trans)).AfterComplete(
        [this, inviterAccount, sharesAddress](bool success)
    {
        if (!success)
        {
            ChatHandler(this).SendSysMessage("招募关系保存失败，未确认任何绑定；请重试。");
            if (WorldSession* recruiter = sWorldSessionMgr->FindSession(inviterAccount))
                ChatHandler(recruiter).SendSysMessage("招募关系保存失败，未确认任何绑定；请重试。");
            return;
        }
        auto* status = LoginDatabase.GetPreparedStatement(LOGIN_SEL_RAF_STATUS);
        status->SetData(0, GetAccountId());
        GetQueryProcessor().AddCallback(LoginDatabase.AsyncQuery(status).WithPreparedCallback(
            [this, inviterAccount, sharesAddress](PreparedQueryResult result)
            {
                if (!result || result->Fetch()[0].Get<uint32>() != inviterAccount)
                {
                    //By leewheel 2026年11月12日 合并上游 #11823：区分同 IP 达到绑定上限的提示，并中文化
                    char const* refusal = sharesAddress
                        ? "招募未被接受：某账号已被绑定、会形成招募循环，或你所在的共享 IP 已达到招募绑定上限。"
                        : "招募未被接受：某账号已被绑定，或会形成招募循环。";
                    ChatHandler(this).SendSysMessage(refusal);
                    if (WorldSession* recruiter = sWorldSessionMgr->FindSession(inviterAccount))
                        ChatHandler(recruiter).SendSysMessage(refusal);
                    //End By leewheel
                    return;
                }
                recruiterId = inviterAccount;
                UpdateRecruitAFriendRewards(true);
                RefreshRecruitAFriendFlags();
                ChatHandler(this).SendSysMessage("你的账号现已永久被招募，「招募战友」已激活。");
                if (WorldSession* recruiter = sWorldSessionMgr->FindSession(inviterAccount))
                {
                    recruiter->isRecruiter = true;
                    recruiter->RefreshRecruitAFriendFlags();
                    ChatHandler(recruiter).SendSysMessage("招募已接受并永久保存。");
                }
            }));
    });
    return true;
}

SpellCastResult WorldSession::CheckRecruitAFriendSummon(Player const* target) const
{
    if (!_player || !target || target == _player || !_player->IsInWorld() || !target->IsInWorld() ||
        target->GetSession()->GetAccountId() == GetAccountId())
        return SPELL_FAILED_BAD_TARGETS;
    if (target->GetSession()->GetRecruiterId() != GetAccountId() && recruiterId != target->GetSession()->GetAccountId())
        return SPELL_FAILED_BAD_TARGETS;
    if (target->GetTeamId() != _player->GetTeamId())
        return SPELL_FAILED_BAD_TARGETS;
    if (target->GetLevel() >= sWorld->getIntConfig(CONFIG_MAX_RECRUIT_A_FRIEND_BONUS_PLAYER_LEVEL))
        return SPELL_FAILED_HIGHLEVEL;
    if (!_player->IsAlive() || !target->IsAlive() || _player->IsInCombat() || target->IsInCombat() ||
        _player->IsBeingTeleported() || target->IsBeingTeleported() || _player->IsInFlight() || target->IsInFlight() ||
        _player->GetVehicle() || target->GetVehicle())
        return SPELL_FAILED_NOT_HERE;
    Map const* casterMap = _player->FindMap();
    Map const* targetMap = target->FindMap();
    if (!casterMap || !targetMap || casterMap->Instanceable() || targetMap->Instanceable() ||
        _player->GetInstanceId() || target->GetInstanceId())
        return SPELL_FAILED_NOT_HERE;
    return SPELL_CAST_OK;
}

bool WorldSession::ValidateRecruitAFriendSummon(ObjectGuid guid, bool agree)
{
    if (_rafSummoner.IsEmpty())
        return true;
    if (guid != _rafSummoner)
        return false;
    if (_player->GetSummonExpireTimer() <= GameTime::GetGameTime().count())
    {
        _rafSummoner.Clear();
        return false;
    }
    if (agree)
    {
        Player* summoner = ObjectAccessor::FindPlayer(guid);
        if (!summoner || summoner->GetSession()->CheckRecruitAFriendSummon(_player) != SPELL_CAST_OK)
        {
            _rafSummoner.Clear();
            _player->SummonIfPossible(false, guid);
            return false;
        }
    }
    _rafSummoner.Clear();
    return true;
}

namespace
{
    uint8 RecruitRewardRealmMask()
    {
        std::string const modes = sConfigMgr->GetOption<std::string>("CoAChallenges.GameModes.Realm", "");
        for (std::string_view mode : Acore::Tokenize(modes, ',', false))
            if (Acore::String::Trim(std::string(mode)) == "WildCard")
                return 8;
        std::string const model = sConfigMgr->GetOption<std::string>("CoA.ClassModel", "coa");
        if (model == "coa")
            return 1;
        if (model == "hero")
            return 2;
        if (model == "wcr")
            return 4;
        return 0;
    }

    bool ValidRecruitReward(uint32 itemId, uint32 quantity)
    {
        ItemTemplate const* item = sObjectMgr->GetItemTemplate(itemId);
        return item && quantity && item->GetMaxStackSize() &&
            (item->MaxCount <= 0 || quantity <= uint32(item->MaxCount)) &&
            (uint64(quantity) + item->GetMaxStackSize() - 1) / item->GetMaxStackSize() <= 1000;
    }
}

void WorldSession::UpdateRecruitAFriendRewards(bool force)
{
    if (IsBot() || !_player || !_player->IsInWorld())
        return;
    time_t const now = GameTime::GetGameTime().count();
    bool const linked = recruiterId || isRecruiter;
    if ((!force || !linked) && now < _rafRewardsNextUpdate)
        return;
    _rafRewardsNextUpdate = now + (linked ? LinkedRewardInterval : UnlinkedRecoveryInterval) +
        GetAccountId() % RewardSpread;
    if (recruiterId)
    {
        if (!_rafRewardSession)
            Acore::Crypto::GetRandomBytes(reinterpret_cast<uint8*>(&_rafRewardSession), sizeof(_rafRewardSession));
        auto* registration = LoginDatabase.GetPreparedStatement(LOGIN_INS_RAF_ACCOUNT);
        registration->SetData(0, GetAccountId());
        auto* baseline = LoginDatabase.GetPreparedStatement(LOGIN_INS_RAF_PROGRESS);
        baseline->SetData(0, GetAccountId());
        baseline->SetData(1, realm.Id.Realm);
        baseline->SetData(2, _player->GetGUID().GetCounter());
        baseline->SetData(3, _player->GetTotalPlayedTime());
        baseline->SetData(4, _player->GetTotalPlayedTime());
        baseline->SetData(5, _rafRewardSession);
        auto* progress = LoginDatabase.GetPreparedStatement(LOGIN_UPD_RAF_PROGRESS);
        progress->SetData(0, _rafRewardSession);
        progress->SetData(1, _player->GetTotalPlayedTime());
        progress->SetData(2, _rafRewardSession);
        progress->SetData(3, _player->GetTotalPlayedTime());
        progress->SetData(4, _player->GetTotalPlayedTime());
        progress->SetData(5, _rafRewardSession);
        progress->SetData(6, GetAccountId());
        progress->SetData(7, realm.Id.Realm);
        progress->SetData(8, _player->GetGUID().GetCounter());
        auto* validate = LoginDatabase.GetPreparedStatement(LOGIN_UPD_RAF_VALIDATION);
        validate->SetData(0, GetAccountId());
        auto trans = LoginDatabase.BeginTransaction();
        trans->Append(registration);
        trans->Append(baseline);
        trans->Append(progress);
        trans->Append(validate);
        LoginDatabase.DirectCommitTransaction(trans);
    }
    UpdateRecruitMilestoneRewards();
    RecoverRecruitAFriendRewards();
    RecoverRecruitAFriendRewards(true);
}

void WorldSession::UpdateRecruitMilestoneRewards()
{
    if (!_player || !recruiterId)
        return;

    uint32 reachedLevel = _player->GetLevel();
    if (PlayerSettingVector const* settings = _player->FindPlayerSettings("core.coa_prestige");
        settings && !settings->empty() && settings->front().value > 0)
        reachedLevel = std::max(reachedLevel, std::min<uint32>(60,
            sWorld->getIntConfig(CONFIG_MAX_PLAYER_LEVEL)));

    auto* query = WorldDatabase.GetPreparedStatement(WORLD_SEL_RAF_RECRUIT_MILESTONES);
    PreparedQueryResult rewards = WorldDatabase.Query(query);
    if (!rewards)
        return;

    uint8 const realmMask = RecruitRewardRealmMask();
    do
    {
        Field* fields = rewards->Fetch();
        uint32 const rewardId = fields[0].Get<uint32>();
        uint32 const requiredLevel = fields[1].Get<uint8>();
        uint8 const mask = fields[2].Get<uint8>();
        uint32 const itemId = fields[3].Get<uint32>();
        uint32 const quantity = fields[4].Get<uint32>();
        if (!rewardId || !requiredLevel || reachedLevel < requiredLevel || !(mask & realmMask) ||
            (mask & ~15) || !ValidRecruitReward(itemId, quantity))
            continue;

        auto* claim = LoginDatabase.GetPreparedStatement(LOGIN_INS_RAF_RECRUIT_CLAIM);
        claim->SetData(0, GetAccountId());
        claim->SetData(1, rewardId);
        claim->SetData(2, realm.Id.Realm);
        claim->SetData(3, _player->GetGUID().GetCounter());
        claim->SetData(4, itemId);
        claim->SetData(5, quantity);
        claim->SetData(6, GetAccountId());
        LoginDatabase.DirectExecute(claim);
    } while (rewards->NextRow());
}

void WorldSession::RecoverRecruitAFriendRewards(bool recruit)
{
    auto* claims = LoginDatabase.GetPreparedStatement(
        recruit ? LOGIN_SEL_RAF_RECRUIT_CLAIMS : LOGIN_SEL_RAF_CLAIMS);
    claims->SetData(0, GetAccountId());
    GetQueryProcessor().AddCallback(LoginDatabase.AsyncQuery(claims).WithPreparedCallback(
        [this, recruit](PreparedQueryResult rows)
        {
            DeliverRecruitAFriendRewards(std::move(rows), recruit);
        }));
}

void WorldSession::DeliverRecruitAFriendRewards(PreparedQueryResult rows, bool recruit)
{
    if (!rows)
        return;
    do
    {
        Field* fields = rows->Fetch();
        if (fields[2].Get<uint32>() != realm.Id.Realm || !fields[6].IsNull())
            continue;
        uint64 const claimId = fields[0].Get<uint64>();
        ObjectGuid::LowType const guid = fields[3].Get<uint32>();
        uint32 const itemId = fields[4].Get<uint32>();
        uint32 const quantity = fields[5].Get<uint32>();
        auto receiptQuery = [claimId, recruit]()
        {
            auto* stmt = CharacterDatabase.GetPreparedStatement(
                recruit ? CHAR_SEL_RAF_RECRUIT_DELIVERY : CHAR_SEL_RAF_DELIVERY);
            stmt->SetData(0, claimId);
            return CharacterDatabase.Query(stmt);
        };
        PreparedQueryResult receipt = receiptQuery();
        if (!receipt)
        {
            if (!ValidRecruitReward(itemId, quantity))
                continue;
            auto* ownerQuery = CharacterDatabase.GetPreparedStatement(CHAR_SEL_RAF_RECIPIENT);
            ownerQuery->SetData(0, guid);
            PreparedQueryResult owner = CharacterDatabase.Query(ownerQuery);
            if (!owner || owner->Fetch()[0].Get<uint32>() != GetAccountId())
                continue;
            ItemTemplate const* itemTemplate = sObjectMgr->GetItemTemplate(itemId);
            auto trans = CharacterDatabase.BeginTransaction();
            std::vector<std::unique_ptr<MailDraft>> drafts;
            std::vector<StagedMail> staged;
            uint32 remaining = quantity;
            bool valid = true;
            while (remaining && valid)
            {
                auto draft = std::make_unique<MailDraft>(RECRUIT_A_FRIEND_REWARD_MAIL_SUBJECT,
                    recruit ? "Welcome! Your recruit milestone reward is enclosed. Each milestone is rewarded once per account on this realm." :
                    "Thank you for recruiting your friends! Your account-wide reward is enclosed.");
                for (uint32 slot = 0; remaining && slot < MAX_MAIL_ITEMS; ++slot)
                {
                    uint32 const count = std::min(remaining, itemTemplate->GetMaxStackSize());
                    Item* item = Item::CreateItem(itemId, count, nullptr);
                    if (!item)
                    {
                        valid = false;
                        break;
                    }
                    item->SaveToDB(trans);
                    draft->AddItem(item);
                    remaining -= count;
                }
                auto mail = valid ? draft->StageMailTo(trans, guid,
                    MailSender(MAIL_NORMAL, 0, MAIL_STATIONERY_GM)) : std::nullopt;
                if (!mail)
                    valid = false;
                else
                    staged.push_back(*mail);
                drafts.push_back(std::move(draft));
            }
            if (!valid)
            {
                for (auto const& draft : drafts)
                    draft->DiscardItems();
                continue;
            }
            auto* marker = CharacterDatabase.GetPreparedStatement(
                recruit ? CHAR_INS_RAF_RECRUIT_DELIVERY : CHAR_INS_RAF_DELIVERY);
            marker->SetData(0, claimId);
            marker->SetData(1, GetAccountId());
            marker->SetData(2, guid);
            marker->SetData(3, staged.front().mailId);
            trans->Append(marker);
            CharacterDatabase.DirectCommitTransaction(trans);
            receipt = receiptQuery();
            bool const committed = receipt && receipt->Fetch()[0].Get<uint32>() == staged.front().mailId;
            for (std::size_t index = 0; index < drafts.size(); ++index)
            {
                if (committed)
                    drafts[index]->PublishStagedMail(staged[index], ObjectAccessor::FindPlayerByLowGUID(guid));
                else
                    drafts[index]->DiscardItems();
            }
        }
        if (receipt)
        {
            auto* delivered = LoginDatabase.GetPreparedStatement(
                recruit ? LOGIN_UPD_RAF_RECRUIT_CLAIM_DELIVERED : LOGIN_UPD_RAF_CLAIM_DELIVERED);
            delivered->SetData(0, claimId);
            LoginDatabase.DirectExecute(delivered);
        }
    } while (rows->NextRow());
}

bool WorldSession::HandleRecruitAFriendRewardsCommand(std::string const& command)
{
    if (!_player || !_player->IsInWorld())
        return false;
    ChatHandler chat(this);
    if (command == "levels")
    {
        chat.PSendSysMessage("{} 拥有 {} 点已存储的招募等级额度。每点额度可让另一个角色提升一级。",
            _player->GetName(), uint32(_player->GetGrantableLevels()));
        chat.SendSysMessage("额度属于该角色。可以用于你的招募者或你直接招募的角色，不能用于自己账号下或其他招募者的角色。");
        chat.PSendSysMessage("接受者必须与你在同一队伍、同一地图且距离不远、等级低于你，同时低于招募等级上限 {} 以及其自身的等级上限。",
            sWorld->getIntConfig(CONFIG_MAX_RECRUIT_A_FRIEND_BONUS_PLAYER_LEVEL));
        chat.SendSysMessage("双方角色都必须存活、脱离战斗、未在飞行或传送中。已激活的威望及其他服务器进度限制也可能阻止授予。");
        Player* target = _player->GetSelectedPlayer();
        if (!target || target == _player)
        {
            chat.SendSysMessage("请选中想要授予的目标，再使用一次 .raf levels 检查其当前是否符合条件。真正授予请使用角色头像菜单中的「授予等级」。");
            return true;
        }
        char const* reason = nullptr;
        switch (GrantLevelError(_player, target))
        {
            case ERR_REFER_A_FRIEND_NONE: break;
            case ERR_REFER_A_FRIEND_NO_TARGET: reason = "请选中另一位玩家"; break;
            case ERR_REFER_A_FRIEND_INSUFFICIENT_GRANTABLE_LEVELS: reason = "你没有已存储的额度"; break;
            case ERR_REFER_A_FRIEND_NOT_REFERRED_BY:
                reason = "两个账号之间不是直接的招募者/被招募者关系";
                break;
            case ERR_REFER_A_FRIEND_TARGET_TOO_HIGH: reason = "接受者的等级必须低于你"; break;
            case ERR_REFER_A_FRIEND_GRANT_LEVEL_MAX_I: reason = "接受者已达到可授予等级上限"; break;
            case ERR_REFER_A_FRIEND_NOT_IN_GROUP: reason = "你们必须在同一队伍中"; break;
            case ERR_REFER_A_FRIEND_TOO_FAR: reason = "你们必须在同一地图且距离不远"; break;
            default: reason = "当前角色状态或服务器进度限制导致无法授予"; break;
        }
        if (!reason && target->GetSession()->_rafGrantExpiry > GameTime::GetGameTime().count())
            reason = "接受者已有一条待处理的授予等级请求";
        if (reason)
            chat.PSendSysMessage("{} 目前无法获得等级：{}。", target->GetName(), reason);
        else
            chat.PSendSysMessage("{} 当前符合招募授予条件。需要接受者确认；接受时会再次校验条件。",
                target->GetName());
        return true;
    }
    UpdateRecruitAFriendRewards(true);
    if (command == "status")
    {
        auto* stmt = LoginDatabase.GetPreparedStatement(LOGIN_SEL_RAF_RECRUITS);
        stmt->SetData(0, GetAccountId());
        PreparedQueryResult result = LoginDatabase.Query(stmt);
        uint32 total = 0;
        uint32 validated = 0;
        if (result)
        {
            do
            {
                Field* fields = result->Fetch();
                ++total;
                bool const valid = !fields[1].IsNull();
                validated += valid;
                chat.PSendSysMessage("被招募者 {}：{}（其最佳角色已在线 {} / 7200 秒）。",
                    fields[0].Get<uint32>(), valid ? "已通过验证" : "待验证", fields[2].Get<uint64>());
            } while (result->NextRow());
        }
        chat.PSendSysMessage("直接招募：共 {} 个，已通过 {} 个，待验证 {} 个。进度每分钟更新一次。",
            total, validated, total - validated);
        return true;
    }
    if (recruiterId && (command == "rewards" || command == "claim"))
    {
        std::unordered_map<uint32, bool> recruitClaims;
        auto* recruitQuery = LoginDatabase.GetPreparedStatement(LOGIN_SEL_RAF_RECRUIT_CLAIMS);
        recruitQuery->SetData(0, GetAccountId());
        if (PreparedQueryResult claims = LoginDatabase.Query(recruitQuery))
        {
            do
            {
                Field* fields = claims->Fetch();
                if (fields[2].Get<uint32>() == realm.Id.Realm)
                    recruitClaims.emplace(fields[1].Get<uint32>(), !fields[6].IsNull());
            } while (claims->NextRow());
        }
        auto* milestonesQuery = WorldDatabase.GetPreparedStatement(WORLD_SEL_RAF_RECRUIT_MILESTONES);
        if (PreparedQueryResult milestones = WorldDatabase.Query(milestonesQuery))
        {
            uint8 const mode = RecruitRewardRealmMask();
            do
            {
                Field* fields = milestones->Fetch();
                uint8 const mask = fields[2].Get<uint8>();
                uint32 const itemId = fields[3].Get<uint32>();
                uint32 const quantity = fields[4].Get<uint32>();
                if (!(mask & mode) || (mask & ~15) || !ValidRecruitReward(itemId, quantity))
                    continue;
                ItemTemplate const* item = sObjectMgr->GetItemTemplate(itemId);
                if (item)
                {
                    uint32 const id = fields[0].Get<uint32>();
                    uint32 const requiredLevel = fields[1].Get<uint8>();
                    auto const claim = recruitClaims.find(id);
                    char const* state = claim != recruitClaims.end() ?
                        (claim->second ? "已邮寄" : "等待原角色领取投递") :
                        _player->GetLevel() >= requiredLevel ? "未投递；可用 .raf claim 重试" : "未解锁";
                    chat.PSendSysMessage("招募里程碑 {}（等级 {}）：{} x{} - {}。每个账号在本服自动发放一次。",
                        id, requiredLevel, item->Name1, quantity, state);
                }
            } while (milestones->NextRow());
        }
    }
    auto* countQuery = LoginDatabase.GetPreparedStatement(LOGIN_SEL_RAF_VALID_COUNT);
    countQuery->SetData(0, GetAccountId());
    PreparedQueryResult countResult = LoginDatabase.Query(countQuery);
    if (!countResult)
    {
        chat.SendSysMessage("无法检查招募资格，请重试。");
        return true;
    }
    uint64 const count = countResult->Fetch()[0].Get<uint64>();
    auto* claimQuery = LoginDatabase.GetPreparedStatement(LOGIN_SEL_RAF_CLAIMS);
    claimQuery->SetData(0, GetAccountId());
    PreparedQueryResult claims = LoginDatabase.Query(claimQuery);
    std::unordered_map<uint32, bool> claimed;
    if (claims)
    {
        do
        {
            Field* fields = claims->Fetch();
            claimed.emplace(fields[1].Get<uint32>(), !fields[6].IsNull());
        } while (claims->NextRow());
    }
    uint32 requested = 0;
    if (command != "rewards" && command != "claim")
    {
        auto id = command.rfind("claim ", 0) == 0 ? Acore::StringTo<uint32>(command.substr(6)) : std::nullopt;
        if (!id || !*id)
        {
            chat.SendSysMessage("用法：.raf claim <奖励编号>");
            return true;
        }
        requested = *id;
        if (auto existing = claimed.find(requested); existing != claimed.end())
        {
            chat.SendSysMessage(existing->second ? "该奖励已邮寄到你的账号。" :
                "该奖励保留给原角色与原服务器投递；登录时会自动在该处补发。");
            return true;
        }
    }
    auto* rewardsQuery = WorldDatabase.GetPreparedStatement(WORLD_SEL_RAF_REWARDS);
    PreparedQueryResult rewards = WorldDatabase.Query(rewardsQuery);
    bool listed = false;
    uint8 const realmMask = RecruitRewardRealmMask();
    if (rewards)
    {
        do
        {
            Field* fields = rewards->Fetch();
            uint32 const id = fields[0].Get<uint32>();
            uint32 const needed = fields[1].Get<uint32>();
            uint8 const mask = fields[2].Get<uint8>();
            uint32 const itemId = fields[3].Get<uint32>();
            uint32 const quantity = fields[4].Get<uint32>();
            if (!(mask & realmMask) || (mask & ~15) || (requested && requested != id))
                continue;
            bool const valid = ValidRecruitReward(itemId, quantity);
            if (!requested)
            {
                auto existing = claimed.find(id);
                char const* state = existing != claimed.end() ? (existing->second ? "已领取" : "等待投递") :
                    !valid ? "配置无效" : count >= needed ? "可领取" : "未解锁";
                ItemTemplate const* item = sObjectMgr->GetItemTemplate(itemId);
                chat.PSendSysMessage("奖励 {}：{}（物品 {}）x{}，需要 {} 个已通过验证的直接招募 - {}。领取：.raf claim {}",
                    id, item ? item->Name1 : std::to_string(itemId), itemId, quantity, needed, state, id);
                listed = true;
                continue;
            }
            if (!valid || count < needed)
            {
                chat.SendSysMessage("该奖励尚未解锁，或其物品配置无效。");
                return true;
            }
            auto* reserve = LoginDatabase.GetPreparedStatement(LOGIN_INS_RAF_CLAIM);
            reserve->SetData(0, GetAccountId());
            reserve->SetData(1, id);
            reserve->SetData(2, realm.Id.Realm);
            reserve->SetData(3, _player->GetGUID().GetCounter());
            reserve->SetData(4, itemId);
            reserve->SetData(5, quantity);
            reserve->SetData(6, GetAccountId());
            reserve->SetData(7, needed);
            LoginDatabase.DirectExecute(reserve);
            RecoverRecruitAFriendRewards();
            chat.SendSysMessage("领取已处理。可用 .raf rewards 查看投递状态；已投递的物品在你的邮箱中。");
            return true;
        } while (rewards->NextRow());
    }
    if (!listed)
        chat.SendSysMessage(requested ? "本服没有该编号的可用奖励。" :
            "本服尚未配置任何可用奖励。");
    return true;
}
