/*
 * mod-coa-challenges (review split): shared umbrella header.
 * Generated from review-CoAChallenges.cpp by review-split/split.ps1.
 * Structs, small constants, extern globals + forward declarations shared
 * by the CoA.Challenges.*.cpp translation units. Not compiled directly.
 */
#ifndef COA_CHALLENGES_REVIEW_H
#define COA_CHALLENGES_REVIEW_H

#include "AscensionCoAConfig.h"
#include "ScriptMgr.h"
#include "Player.h"
#include "Bag.h"
#include "DBCStores.h"
#include "WorldSession.h"
#include "WorldSessionMgr.h"
#include "WorldPacket.h"
#include "Opcodes.h"
#include "Config.h"
#include "Log.h"
#include "DatabaseEnv.h"
#include "SpellMgr.h"
#include "SpellAuras.h"
#include "Spell.h"
#include "Group.h"
#include "GameEventMgr.h"
#include "ObjectAccessor.h"
#include "CharacterCache.h"
#include "Chat.h"
#include "CommandScript.h"
#include "CoA.Prestige.API.h"
#include "CoAChallengeParse.h"
#include "CoAChallengeInternal.h"
#include "MiscScript.h"
#include "ObjectMgr.h"
#include "TaskScheduler.h"
#include "StringFormat.h"
#include "SmartEnum.h"
#include "Timer.h"
#include "WorldSessionMgr.h"
#include <algorithm>
#include <array>
#include <atomic>
#include <cctype>
#include <chrono>
#include <ctime>
#include <memory>
#include <map>
#include <mutex>
#include <set>
#include <thread>
#include <utility>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

namespace CoAChallenges
{
    // ------------------------------------------------------------------ strings
    // Every player-facing string lives in the world database, the same way
    // mod-worldforged-upgrades and mod-coa-mythic-plus do it: the ids below are
    // rows of `module_string` (English) and `module_string_locale` (one row per
    // locale), resolved at runtime by the player's session locale. Ids are
    // stable: append, never reorder - they are primary keys in the database.
    // The matching SQL is
    // data/sql/db-world/2026_10_19_00_mod_coa_challenges_module_strings.sql.
    constexpr char const* MODULE_NAME = "mod-coa-challenges";

    enum ChallengeStrings : uint32
    {
        STR_RULE_LEFT_HIGH_RISK      =   1, // You left High Risk and failed your challenge.
        STR_RULE_NO_MAIL             =   2, // Your challenge forbids receiving mail.
        STR_RULE_NO_MANASTORM        =   3, // Your challenge forbids entering the Manastorm.
        STR_RULE_TRADE_SAME          =   4, // Trade is restricted: both players must share the same challenge(s).
        STR_RULE_NO_TRADE            =   5, // Your challenge forbids trading.
        STR_RULE_NO_MAILBOX          =   6, // Your challenge forbids using the mailbox.
        STR_RULE_NO_GROUP_JOIN       =   7, // Your challenge forbids joining a group.
        STR_RULE_NO_INTERACT         =   8, // Your challenge forbids interacting with other players.
        STR_RULE_NO_GROUP_DUNGEON    =   9, // Your challenge forbids grouping inside a dungeon.
        STR_RULE_GROUP_SAME          =  10, // You can only group with players in the same challenge.
        STR_RULE_GROUP_3LEVEL        =  11, // Your challenge only allows grouping within 3 levels.
        STR_RULE_NO_QUESTS           =  12, // Your challenge forbids completing quests.
        STR_RULE_NO_QUEST            =  13, // Your challenge forbids completing this quest.
        STR_RULE_NO_QUEST_ACCEPT     =  14, // Your challenge forbids accepting this quest.
        STR_RULE_NO_HEARTHSTONE      =  15, // Your challenge forbids using the hearthstone.
        STR_RULE_NO_BOOST            =  16, // Your challenge forbids using boosting items.
        STR_RULE_NO_XP_ITEMS         =  17, // Your challenge forbids bonus experience items.
        STR_RULE_NO_MOUNTS           =  18, // Your challenge forbids using mounts.
        STR_RULE_NO_COSMETIC_PETS    =  19, // Your challenge forbids cosmetic pets.
        STR_RULE_NO_POTIONS          =  20, // Your challenge forbids using potions.
        STR_RULE_NO_VENDOR_BUY       =  21, // Your challenge forbids buying from vendors.
        STR_RULE_NO_VENDOR_FOOD      =  22, // Your challenge forbids buying food or drinks from vendors.
        STR_RULE_NO_VENDOR_USE       =  23, // Your challenge forbids using vendors.
        STR_RULE_NO_BUYBACK          =  24, // Your challenge forbids vendor buyback.
        STR_RULE_NO_RAIDS            =  25, // Your challenge forbids entering raids.
        STR_RULE_NO_DUNGEONS         =  26, // Your challenge forbids entering dungeons.
        STR_RULE_NO_CONTINENT        =  27, // Your challenge forbids leaving the continent.
        STR_RULE_ONLY_CRAFTED        =  28, // Your challenge only allows items you crafted yourself.
        STR_RULE_ONLY_LOOTED         =  29, // Your challenge only allows items you looted yourself.
        STR_RULE_NO_ARMOR            =  30, // Your challenge forbids equipping armor.
        STR_RULE_NO_BAGS             =  31, // Your challenge forbids additional bags.
        STR_RULE_PROF_LOCKED         =  32, // Your profession choices are permanent.
        STR_RULE_NO_BANK             =  33, // Your challenge forbids using banks.
        STR_RULE_NO_REPAIR           =  34, // Your challenge forbids repairing items.
        STR_RULE_NO_LOOT             =  35, // Your challenge forbids looting items.
        STR_RULE_NO_FLIGHT           =  36, // Your challenge forbids using flight paths.
        STR_RULE_NO_AH               =  37, // Your challenge forbids using the auction house.
        STR_RULE_NO_GUILD_BANK       =  38, // Your challenge forbids using the guild bank.
        STR_RULE_SLAIN_FORBIDDEN     =  39, // You have slain a forbidden creature and failed your challenge.
        STR_RULE_ABANDONED           =  40, // You have abandoned {} and failed it.
        STR_RULE_MARK_DEATH          =  41, // You cast a spell marked for death and it kills you.
        STR_RULE_SPELL_FORBIDDEN     =  42, // That spell is forbidden by your challenge.
        STR_RULE_NO_PORTALS          =  43, // Your challenge forbids using portals.
        STR_RULE_MELEE_ONLY          =  44, // Your challenge limits your cast range to melee.
        STR_RULE_NO_PROFESSIONS      =  45, // Your challenge forbids using professions.
        STR_RULE_NO_COMPANIONS       =  46, // Your challenge forbids companion pets.
        STR_RULE_NO_MINIONS          =  47, // Your challenge forbids pets and minions.
        STR_RULE_TAPPED              =  48, // This target is already tapped by another challenge.
        STR_RULE_PVE_ONLY            =  49, // Your challenge is PvE only: you cannot fight players.
        STR_RULE_PVP_LIMIT           =  50, // Your challenge restricts who you may fight in PvP.
        STR_RULE_FELL                =  51, // You have fallen and failed your challenge.
        STR_RULE_LAVA                =  52, // The floor is lava! Your challenge has failed.
        STR_ACT_NOT_FOUND            =  53, // Challenge {} was not found.
        STR_ACT_NO_REWARDS           =  54, // {} has no rewards.
        STR_ACT_ALREADY_ACTIVE       =  55, // {} is already active.
        STR_ACT_CONFLICT             =  56, // You already have an active challenge that conflicts ({}).
        STR_ACT_EVENT                =  57, // {} requires a game event that is not active.
        STR_ACT_CONDITIONS           =  58, // Cannot start {}: {}
        STR_ACT_LEAVE_GROUP          =  59, // You must leave your group before starting {}.
        STR_ACT_HIGH_RISK            =  60, // {} requires you to be in High Risk.
        STR_ACT_PRESTIGE             =  61, // {} requires prestige.
        STR_ACT_ANY_FAILED           =  62, // You have already failed a challenge and cannot start another.
        STR_ACT_FAILED_RETAKE        =  63, // You have already failed {} and cannot retake it.
        STR_ACT_COMPLETED            =  64, // You have already completed this trial ({}).
        STR_GRP_KICKED               =  65, // You have been removed from the group: it now requires the same challenge set.
        STR_MODE_FAILED              =  66, // Your {} challenge has failed.
        STR_TRIAL_SAVE_CONFLICT      =  67, // A trial cannot combine two mutually exclusive challenges ({} and {}).
        STR_TRIAL_ACT_CONFLICT       =  68, // This trial combines two mutually exclusive challenges ({} and {}).
        STR_HUNGER_CRITICAL          =  69, // Challenge: your {} is critical ({})! Eat or drink soon.
        STR_KIND_HUNGER              =  70, // hunger
        STR_KIND_THIRST              =  71, // thirst
        STR_CAUSE_ASLEEP             =  72, // Fell Asleep
        STR_CAUSE_STARVED            =  73, // Starved
        STR_OBJ_GREEDY               =  74, // Greedy
        STR_OBJ_HUNT                 =  75, // Hunt Failed
        STR_OBJ_LOOT                 =  76, // Loot Failed
        STR_OBJ_QUEST                =  77, // Quest Failed
        STR_OBJ_DUO                  =  78, // Duo Broken
        STR_OBJ_TRIO                 =  79, // Trio Broken
        STR_OBJ_FAILED               =  80, // Failed Objective
        STR_ENV_EXHAUSTION           =  81, // Exhaustion
        STR_ENV_DROWNING             =  82, // Drowning
        STR_ENV_FALLING              =  83, // Falling
        STR_ENV_LAVA                 =  84, // Lava
        STR_ENV_SLIME                =  85, // Slime
        STR_ENV_FIRE                 =  86, // Fire
        STR_ENV_GENERIC              =  87, // Environment
        STR_CAUSE_UNKNOWN            =  88, // Unknown
        STR_BC_COMPLETED             =  89, // {} has completed their Trial!
        STR_BC_FAIL_HEAD             =  90, // {} {} (Level {}) {}
        STR_BC_KILLED                =  91, // has been killed by {}.
        STR_BC_SLAYING               =  92, // has failed the challenge by slaying {}.
        STR_GM_NO_PLAYER             =  93, // No player (target someone or run it yourself).
        STR_GM_UNLOCKED              =  94, // Unlocked {} from challenge {}.
        STR_GM_NO_LOCK               =  95, // {} had no failure lock on challenge {}.
        STR_GM_ONLINE_CHECK          =  96, // Player must be online to check conditions.
        STR_GM_COND_HEAD             =  97, // Conditions for challenge {} ({}):
        STR_GM_COND_NONE             =  98, //   (none)
        STR_GM_COND_BROKEN           =  99, //   {}: BROKEN ({})
        STR_GM_COND_OK               = 100, //   {}: ok ({})
        STR_GM_COND_ACTIVATE         = 101, //   => OK (can activate)
        STR_GM_COND_BLOCKED          = 102, //   => BLOCKED: {}
        STR_GM_ONLINE_SYNC           = 103, // Player must be online to send a sync request.
        STR_GM_NO_GROUP              = 104, // {} is not in a group.
        STR_GM_SYNC_SENT             = 105, // Sent CHALLENGES_SYNC (0x59B) for challenge {} level {} to {}'s party.
        STR_GM_RELOADED              = 106, // Reloaded {} challenge definition(s) from the database.
        STR_GM_ONLINE                = 107, // Player must be online.
        STR_GM_UNKNOWN_MODE          = 108, // Unknown game mode '{}'.
        STR_GM_MODE_ON               = 109, // Game mode {} enabled for {}.
        STR_GM_MODE_OFF              = 110, // Game mode {} disabled for {}.
        STR_GM_NO_FATIGUE            = 111, // {} has no active FATIGUED_UNLESS_RESTED challenge.
        STR_GM_FATIGUE_RESTING       = 112, // Fatigue[{}] = {}/{} (resting=yes)
        STR_GM_FATIGUE_AWAKE         = 113, // Fatigue[{}] = {}/{} (resting=no)
        STR_GM_NO_REWARD_DATA        = 114, // Challenge {} level {} has no reward data.
        STR_GM_REWARD_HEAD           = 115, // Rewards for challenge {} level {} ({} entries):
        STR_GM_REWARD_ROW            = 116, //   item={} x{} ach={} special={} first={}
        STR_GM_REWARD_LISTED         = 117, // Listed only (no online player; usage: .coa reward <id> [level] [player]).
        STR_GM_REWARD_DELIVERED      = 118, // Delivered to {} (check the mailbox / achievements).
        STR_GM_OFFLINE               = 119, // Player '{}' is not online.
        STR_GM_E2E_RESET             = 120, // E2E: reset '{}' before running trial {}.
        STR_GM_E2E_RUN               = 121, // E2E trial {} ({}): scheduled, interval {} ms. Watch the client.
        STR_GM_E2E_PASS              = 122, // E2E PASS
        STR_GM_E2E_FAIL              = 123, // E2E FAIL
        STR_GM_E2E_LEVELGATE         = 124, // E2E level-gate {} ({}): scheduled, interval {} ms. Watch the client.
        STR_GM_E2E_FATIGUE           = 125, // E2E fatigue {} ({}): scheduled, interval {} ms. Watch the client.
        STR_GM_E2E_MISS_RESET        = 126, // E2E(miss): reset '{}' before running trial {}.
        STR_GM_E2E_MISS_RUN          = 127, // E2E miss {} ({}): scheduled, interval {} ms. Watch the client.
        STR_GM_NOT_GATED             = 128, // Trial {} is not a level-gated trial (no miss path).
        STR_GM_RULE_PASS             = 129, // RULE TEST PASS (challenge {})
        STR_GM_RULE_FAIL             = 130, // RULE TEST FAIL (challenge {})
        STR_GM_RULE_GATES_PASS       = 131, // RULE GATES PASS
        STR_GM_RULE_GATES_FAIL       = 132, // RULE GATES FAIL (see per-rule lines above)
        STR_GM_COND_GATES_PASS       = 133, // CONDITION GATES PASS
        STR_GM_COND_GATES_FAIL       = 134, // CONDITION GATES FAIL (see per-condition lines above)
        STR_GM_FLAG_SET              = 135, // Set condition flag '{}' for {}.
        STR_GM_FLAG_CLEARED          = 136, // Cleared condition flag '{}' for {}.
        STR_GM_BOTH_ONLINE           = 137, // Both players must be online ('{}' / '{}').
        STR_GM_PARTY_PASS            = 138, // PARTY RULE GATES PASS
        STR_GM_PARTY_FAIL            = 139, // PARTY RULE GATES FAIL (see lines above)
        STR_GM_RULE_AUDIT            = 140, // Rule audit finished for {} (check chat/log for divergences).
        STR_GM_DEF_AUDIT             = 141, // Definition audit finished for {} (check chat/log for divergences).
        STR_GM_TOCTOU_PASS           = 142, // CACHE TOCTOU PASS
        STR_GM_TOCTOU_FAIL           = 143, // CACHE TOCTOU FAIL (see lines above)
        STR_GM_PET_PASS              = 144, // PET TRIAL AURAS PASS
        STR_GM_PET_FAIL              = 145, // PET TRIAL AURAS FAIL (see lines above)
        STR_GM_RESET_USAGE           = 146, // Usage: .coa reset all <player>
        STR_GM_HARD_RESET            = 147, // Hard reset ALL for {}: level 1, 0 money, no CoA state, repairs, spells/talents/skills unlearned, quest log cleared.
        STR_GM_RESET_DONE            = 148, // Reset challenge state for {} (level/money/items kept).
        STR_GM_PRESTIGE_SPELL        = 149, // Spell {} (prestige aura) is unknown to the server.
        STR_GM_PRESTIGE_ON           = 150, // {} is now PRESTIGED (aura {}).
        STR_GM_PRESTIGE_OFF          = 151, // {} is no longer prestiged.
        STR_GM_ENVTEST_USAGE         = 152, // Player must be online (usage: .coa envtest <type> [damage] [player]).
        STR_GM_ENVTEST_DONE          = 153, // Applied environmental type {} ({} raw) to {}: {} applied.
        STR_ROULETTE_1               = 154, // A new spell is bound by the roulette! {} is now a forbidden incantation.
        STR_ROULETTE_2               = 155, // A dire warning: {} is now ensnared by the curse - cast it at your own peril.
        STR_ROULETTE_3               = 156, // The curse has moved! {} is now perilous to cast - heed the warning.
        STR_ROULETTE_4               = 157, // The roulette of fate has chosen its next victim: {}. Cast it not, lest death be your reward.
        STR_ROULETTE_5               = 158, // The curse has found a new host! {} is now lethal to cast - heed this omen.
        STR_ROULETTE_6               = 159, // Beware, traveler! The spell {} is now forbidden - cast it not, lest you perish.
        STR_ROULETTE_7               = 160, // A new spell is bound by fate! Avoid casting {}, or meet your doom.
        STR_ROULETTE_8               = 161, // The forbidden seal has shifted! {} is now a spell of certain demise.
        STR_ROULETTE_9               = 162, // The roulette has spun! Casting {} is now a fatal gamble.
        STR_ROULETTE_10              = 163, // The winds of fate have changed! {} is now deadly to invoke.
        STR_COND_SOLO                = 164, // This trial must be started solo (you are in a group of {}).
        STR_COND_GROUP               = 165, // This trial requires a group of {} (you have {}).
        STR_COND_SLOTS               = 166, // You need at least {} free inventory slots (you have {}).
        STR_COND_PROF2               = 167, // You cannot have two primary professions (you have {}).
        STR_COND_LOOTED              = 168, // You have already looted something; this trial must be started before any loot interaction.
        STR_COND_XP                  = 169, // You have already gained experience; this trial must be started at level 1.
        STR_COND_UNSUPPORTED         = 170, // This trial has an unsupported activation requirement and cannot be started.
        STR_COND_ALREADY             = 171, // You have already {} before starting this trial.
        STR_FACET_MAIL               = 172, // taken items or money from the mailbox
        STR_FACET_TRADE              = 173, // traded with another player
        STR_FACET_AH                 = 174, // used the auction house
        STR_FACET_VENDOR             = 175, // used a vendor
        STR_FACET_GUILD_BANK         = 176, // withdrawn from the guild bank
        STR_FACET_BANK               = 177, // withdrawn from your bank
        STR_FACET_REALM_BANK         = 178, // withdrawn from your realm bank
        STR_FACET_OUTSIDE            = 179, // interacted with the outside world
        STR_DET_SOLO                 = 180, // requires solo, current group of {}
        STR_DET_SOLO_OK              = 181, // solo
        STR_DET_REQUIRES             = 182, // requires {}, current {}
        STR_DET_PROF                 = 183, // primary professions: {}
        STR_DET_LADDER               = 184, // not required for a multi-level challenge
        STR_DET_LOOTED               = 185, // LOOTED
        STR_DET_CLEAN                = 186, // clean
        STR_DET_LEVEL1               = 187, // requires level 1, current {}
        STR_DET_INTERACTED           = 188, // INTERACTED
        STR_DET_UNHANDLED            = 189, // unhandled condition type
        STR_ACT_MODE_BLOCKED         = 190, // Adventure Mode cannot change during combat, an encounter, death, flight, control or teleportation. Your party and pets must also be out of combat.
        STR_ACT_LEVEL_LOWER          = 191, // Choose a lower Adventure Mode level, at least 1.
        STR_ACT_TRIAL_LOCK           = 192, // Cannot lower a custom trial or select an Adventure Mode level already completed.
        STR_ACT_MODE_REDUCED         = 193, // Adventure Mode reduced to level {}. Difficulty and rewards now use this level.
    };

    /// One row of `module_string`, in the given session locale. A missing row
    /// is a deployment error the core logs; the literal "error" is shown.
    inline std::string MLStr(uint32 id, int32 locale)
    {
        std::string const* str = sObjectMgr->GetModuleString(MODULE_NAME, id,
            locale >= 0 && size_t(locale) < TOTAL_LOCALES ? LocaleConstant(locale) : LOCALE_enUS);
        return str ? *str : "error";
    }

    /// The same row, with `{}` placeholders filled in.
    template <typename... Args>
    std::string MLStrFmt(uint32 id, int32 locale, Args const&... args)
    {
        return Acore::StringFormat(MLStr(id, locale), args...);
    }

    /// Realm-wide system-chat announcement in the player's own locale.
    /// `prefix` carries locale-independent decoration (timestamp, challenge
    /// icon tag) that goes in front of the translated body. A single pre-built
    /// packet would freeze every client on the same language, so one packet is
    /// built per distinct session locale (same recipient filter the core's
    /// SendGlobalMessage uses).
    template <typename... Args>
    void BroadcastModuleSysMessage(std::string const& prefix, uint32 id, Args const&... args)
    {
        std::map<int32, WorldPacket> packets;
        for (auto const& [_, session] : sWorldSessionMgr->GetAllSessions())
        {
            if (!session || !session->GetPlayer() || !session->GetPlayer()->IsInWorld())
                continue;
            int32 locale = session->GetSessionDbLocaleIndex();
            auto it = packets.find(locale);
            if (it == packets.end())
            {
                WorldPacket data;
                ChatHandler::BuildChatPacket(data, CHAT_MSG_SYSTEM, LANG_UNIVERSAL,
                    nullptr, nullptr, prefix + MLStrFmt(id, locale, args...));
                it = packets.emplace(locale, std::move(data)).first;
            }
            session->SendPacket(&it->second);
        }
    }

    /// Same, for bodies that must be assembled per locale (the failure
    /// broadcast's killer link carries a localized cause label).
    inline void BroadcastModuleSysMessage(std::string const& prefix,
        std::function<std::string(int32)> const& body)
    {
        std::map<int32, WorldPacket> packets;
        for (auto const& [_, session] : sWorldSessionMgr->GetAllSessions())
        {
            if (!session || !session->GetPlayer() || !session->GetPlayer()->IsInWorld())
                continue;
            int32 locale = session->GetSessionDbLocaleIndex();
            auto it = packets.find(locale);
            if (it == packets.end())
            {
                WorldPacket data;
                ChatHandler::BuildChatPacket(data, CHAT_MSG_SYSTEM, LANG_UNIVERSAL,
                    nullptr, nullptr, prefix + body(locale));
                it = packets.emplace(locale, std::move(data)).first;
            }
            session->SendPacket(&it->second);
        }
    }

    // Broadcast colors, sampled from the live client's chat (2026-09-13):
    //   [TrialName] = FFA500, player name = 43C6DB, killer/cause = FF0000.
    // The body ("has completed their Trial!" / "(Level N) has been killed by")
    // is left uncolored so the client applies the SYSTEM chat default.
    char const* const TRIAL_COLOR = "|cffFFA500";
    char const* const PLAYER_COLOR = "|cff43C6DB";
    char const* const KILLER_COLOR = "|cffff0000";

    // Cause of death for the failure broadcast, resolved when known.
    // Creature/Player get a clickable link; Environment/Self/Mechanic are
    // literal red labels (Falling/Suicide/Starved/...).
    enum class KillerKind : uint8 { Unknown, Creature, Player, Environment, Self, Mechanic, Rule };

    // Failure broadcast. FailChallenge records the failure here for every cause
    // (death, shared fate, group leave). OnPlayerJustDied runs before
    // OnPlayerKilledByCreature / OnPlayerPVPKill, which fill in the killer;
    // the message is flushed on the next world tick.
    // killerSource is the guid whose death carries the killer info: the dead
    // player themselves, or (for shared fate) the member who actually died, so
    // every holder's line names the same killer.
    struct PendingFail
    {
        uint32 challengeID = 0;
        uint32 level = 1;
        KillerKind killerKind = KillerKind::Unknown;
        uint32 killerEntry = 0;
        std::string killerName;
        // When the failed challenge is part of the character's active custom
        // trial, the announcement shows the trial's name/icon instead.
        std::string displayName;
        std::string displayIcon;
        // Module string id for a localized death cause (see PendingKiller).
        uint32 killerStrId = 0;
    };

    // Killer of a player's most recent death, captured by
    // OnPlayerKilledByCreature / OnPlayerPVPKill. Those hooks run at the end of
    // Unit::Kill, BEFORE OnPlayerJustDied (which only runs on the player's next
    // update tick via KillPlayer), so FailChallenge reads it here instead of
    // relying on the hook order.
    struct PendingKiller
    {
        KillerKind kind = KillerKind::Unknown;
        uint32 entry = 0;
        std::string name;
        // When non-zero, the broadcast resolves this module string id in the
        // reader's locale instead of showing `name` (mechanic/environment
        // causes like "Starved"/"Falling"). `name` stays for creature/player
        // killers, whose names already come from the locale tables.
        uint32 strId = 0;
    };

    // Hunger tracking (server-driven; the client only renders).
    // Observed on live (video): thirst +1/10s, hunger +1/16s, eating or
    // drinking DECREASES (not reset), death at 100. Displayed as stacks on
    // separate meter auras (drink glass + ham) that appear once >0.
    //
    // The authoritative values live in memory (like Player's field map) and
    // are flushed to the DB periodically and on logout, mirroring
    // Player::m_nextSave + SaveToDB. This avoids a SELECT/UPDATE per tick.
    struct HungerState { int32 hunger = 0; int32 thirst = 0; };

    struct HungerClock
    {
        uint32 thirstMs = 0;
        uint32 hungerMs = 0;
        uint32 foodMs = 0;
        uint32 drinkMs = 0;
        uint32 flushMs = 0;
        bool dirty = false;
        std::unordered_map<uint32, HungerState> state; // challengeId -> values
    };

    // Eat/drink restore ticks: 1 point per tick while the matching regen
    // aura is up. Observed live: drinking drops ~2x faster than eating.
    uint32 const HUNGER_FOOD_TICK_MS = 500;
    uint32 const HUNGER_DRINK_TICK_MS = 250;
    // Persist cadence for the in-memory counters.
    uint32 const HUNGER_FLUSH_MS = 5000;

    // Sentinel "challenge id" used to run the hunger/thirst system for the
    // Survivalist gamemode (Enum.GameMode.Survivalist, bit 0x4) without a real
    // challenge. Never stored in coa_character_challenge.
    uint32 const SURVIVALIST_HUNGER_ID = 0xFFFFFFFEu;
    uint32 const GAMEMODE_SURVIVALIST  = 0x00000004u;

    // --- Custom game modes -------------------------------------
    // Toggled by the client via CMSG 0x5A4 (mode name string + enable bool).
    // State is a bitmask (Enum.GameMode) pushed with SMSG 0x90B; the toggle
    // result is a "<MODE>_<RESULT>" string on SMSG 0x5A5.
    struct GameModeDef
    {
        char const* name;        // wire name the client sends
        char const* response;    // response prefix ("IRONMAN", "BUILDDRAFT", ...)
        char const* configKey;   // client C_Config key gating (locking) the UI entry
        char const* hiddenKey;   // client C_Config key hiding the row from the tab
        uint32      bit;         // Enum.GameMode bit
    };

    GameModeDef const GameModes[] =
    {
        { "Ironman",     "IRONMAN",     "CONFIG_IRONMAN_ENABLE",      "CONFIG_IRONMAN_HIDDEN",      0x0002 },
        { "Survivalist", "SURVIVALIST", "CONFIG_SURVIALIST_ENABLE",   "CONFIG_SURVIALIST_HIDDEN",   0x0004 },
        { "Draft",       "DRAFT",       "CONFIG_DRAFT_ENABLE",        "CONFIG_DRAFT_HIDDEN",        0x0008 },
        { "Resolute",    "RESOLUTE",    "CONFIG_RESOLUTE_ENABLE",     "CONFIG_RESOLUTE_HIDDEN",     0x0020 },
        { "WildCard",    "WILDCARD",    "CONFIG_WILD_CARD_ENABLE",    "CONFIG_WILD_CARD_HIDDEN",    0x0040 },
        { "Felforged",   "FELFORGED",   "CONFIG_FELFORGED_ENABLED",   "CONFIG_FELFORGED_HIDDEN",    0x0080 },
        { "Nightmare",   "NIGHTMARE",   "CONFIG_NIGHTMARE_ENABLE",    "CONFIG_NIGHTMARE_HIDDEN",    0x0100 },
        { "BuildDraft",  "BUILDDRAFT",  "CONFIG_BUILD_DRAFT_ENABLED", "CONFIG_BUILD_DRAFT_HIDDEN",  0x0800 },
        { "Crusader",    "CRUSADER",    "CONFIG_CRUSADER_ENABLED",    "CONFIG_CRUSADER_HIDDEN",     0x1000 },
    };

    // Hide a mode row from the Gamemodes tab (client CONFIG_*_HIDDEN). Reads the
    // comma-separated wire names in CoAChallenges.GameModes.Hidden. A hidden mode
    // still appears on the client while it is ACTIVE; this is presentation-only.
    bool GameModeHidden(char const* name);

    // Rows pending persistence for one player. Copied out under the lock so
    // the DB commit itself runs without holding HungerMutex.
    struct HungerFlushRow { uint32 challengeID; int32 hunger; int32 thirst; };

    // --- FATIGUED_UNLESS_RESTED (Narcolepsy: 170/171/172/384/385/386) --------
    // Native "fatigue" bar (MirrorTimer type FATIGUE = MirrorTimer1, the yellow
    // exhaustion bar) that FILLS from 0 to max while the player is OUTSIDE a
    // rested area (inn); at max the player falls asleep (dies). Driven entirely
    // server-side (not an aura meter). Only challenges whose Rules list carries
    // CHALLENGE_RULES_TYPE_FATIGUED_UNLESS_RESTED are tracked.
    struct FatigueState { uint32 challengeId = 0; int32 fatigue = 0; uint32 ms = 0; bool resting = true; uint32 graceMs = 0; };

    struct ConditionState { std::string label; bool broken = false; std::string detail; std::string message; };

    // Group challenge sync (SMSG 0x59B / CMSG 0x59C). The client's 0x59B
    // handler stores the {challengeID, level} pairs as "pending" and fires
    // CHALLENGE_SYNC_REQUEST(timeoutMs); UIParent shows CHALLENGES_SYNC when
    // the pending list is non-empty, else CHALLENGES_SYNC_REMOVE. The answer
    // (SendChallengeSyncResponse) is a single accept/decline byte with no ids,
    // so the server remembers what each outstanding request means per player.
    struct PendingSync
    {
        uint32 requesterGuid = 0;                        // activator that asked for the sync
        bool remove = false;                             // true = remove popup
        bool rollbackOnDecline = false;                  // party-required -> decline reverts
        std::vector<std::pair<uint32, uint32>> pairs;    // offered set (wire / applied on accept)
        std::vector<std::pair<uint32, uint32>> rollback; // set to revert on the requester on decline
    };

    // One entry of a challenge's reward list (per level). Empty itemId means
    // the entry is achievement-only (the client export encodes those as
    // "item=0x0|ach=<id>"). isFirst = the reward is only granted on the
    // character's first completion of that level (IsFirstCompletion); entries
    // with isFirst=false are repeatable (the client marks the "special" ones,
    // IsSpecialReward). Delivery is by mail (CoAChallenges.GrantRewards).
    struct RewardDef
    {
        uint32 itemId = 0;
        uint32 amount = 1;
        uint32 achievement = 0;
        bool isSpecial = false;
        bool isFirst = true;
    };

    // Per-challenge definition, DB-first (coa_challenge_definition +
    // coa_challenge_spell + coa_challenge_reward). Loaded into DefCache at
    // startup / `.coa challenges reload`; the world DB is the single source of
    // truth (no generated-.conf fallback).
    struct ChallengeDef
    {
        uint32 id = 0;
        std::string name;
        std::string icon;
        uint32 levelCount = 1;
        bool isTrial = false;
        bool isPrestige = false;
        uint32 exclusiveGroup = 0;
        uint32 requiredGameMode = 0;
        uint32 requiredGameEvent = 0;
        bool noRewards = false;
        bool noResurrect = false;
        uint32 lives = 0;
        bool sharedFate = false;
        bool survivalist = false;
        std::string rules;
        std::string conditions;
        std::string objectives;
        std::map<uint32, std::string> spells; // level -> "a;b" PvE auras (0 = union)
        std::map<uint32, std::vector<RewardDef>> rewards; // level -> reward list
    };

    extern std::mutex DefMutex; // defined in CoA.Challenges.Definitions.cpp
    extern std::unordered_map<uint32, ChallengeDef> DefCache;

    bool DefHas(uint32 challengeID);
    uint32 DefCount();
    std::vector<uint32> DefIds();
    void LoadChallengeDefinitions();

    // DB-only field read: the world DB is the single source of truth for
    // definitions (there is no generated-conf fallback). Misses return the
    // caller's default.
    template <typename T>
    T DefField(uint32 challengeID, T ChallengeDef::*member, std::string const& /*confKey*/, T def)
    {
        std::lock_guard<std::mutex> lock(DefMutex);
        auto it = DefCache.find(challengeID);
        if (it != DefCache.end())
            return it->second.*member;
        return def;
    }

    inline std::string ChallengeRules(uint32 challengeID)
    {
        return DefField<std::string>(challengeID, &ChallengeDef::rules,
            "CoAChallenges.Rules." + std::to_string(challengeID), "");
    }

    inline std::string ChallengeConditions(uint32 challengeID)
    {
        return DefField<std::string>(challengeID, &ChallengeDef::conditions,
            "CoAChallenges.Conditions." + std::to_string(challengeID), "");
    }

// Namespace-scope state (defined once in the domain file noted).
extern std::mutex PendingFailMutex; // defined in CoA.Challenges.Core.cpp
extern std::unordered_map<uint32, PendingFail> PendingFailBroadcast; // defined in CoA.Challenges.Core.cpp
    extern std::mutex LastKillerMutex; // defined in CoA.Challenges.Core.cpp
    extern std::unordered_map<uint32, PendingKiller> LastKiller; // defined in CoA.Challenges.Core.cpp
    extern std::atomic<bool> g_testQuiet; // defined in CoA.Challenges.Core.cpp
extern std::mutex HungerMutex; // defined in CoA.Challenges.Hunger.cpp
extern std::unordered_map<uint32, HungerClock> HungerAccum; // defined in CoA.Challenges.Hunger.cpp
extern std::unordered_set<uint32> HungerGuids; // defined in CoA.Challenges.Hunger.cpp
extern std::unordered_map<uint32, uint32> GameModeBase; // guarded by GameModeBaseMutex; iterate via GameModeBaseSnapshot()
extern std::mutex CharChallengeMutex; // defined in CoA.Challenges.Lifecycle.cpp
// guid -> the character's active challenges, as (challengeId, level)
extern std::unordered_map<uint32, std::vector<std::pair<uint32, uint32>>> CharChallengeCache;
extern std::mutex GameModeMaskMutex; // defined in CoA.Challenges.GameModes.cpp
extern std::unordered_map<uint32, uint32> GameModeMaskCache; // defined in CoA.Challenges.GameModes.cpp
extern std::mutex FatigueMutex; // defined in CoA.Challenges.Fatigue.cpp
extern std::unordered_map<uint32, FatigueState> FatigueStates; // defined in CoA.Challenges.Fatigue.cpp
extern std::mutex ObjectiveCacheMutex; // defined in CoA.Challenges.Lifecycle.cpp
extern std::unordered_map<uint32, std::vector<Objective>> ObjectiveCache; // defined in CoA.Challenges.Lifecycle.cpp
extern std::mutex CraftRarityMutex; // defined in CoA.Challenges.Professions.cpp
extern std::unordered_map<uint32, uint32> CraftRarity; // defined in CoA.Challenges.Professions.cpp
extern std::mutex PendingSyncMutex; // defined in CoA.Challenges.Core.cpp
extern std::unordered_map<uint32, PendingSync> PendingSyncByGuid; // CoA.Challenges.Core.cpp
extern std::atomic<bool> g_suppressSyncBroadcast; // defined in CoA.Challenges.Core.cpp

// Player-facing system message. The GM test harness sets g_testQuiet so a test
// run only prints its PASS/FAIL lines (production always shows the message).
// The text is a ChallengeStrings id: the row is resolved in the player's own
// session locale (module_string / module_string_locale).
template <typename... Args>
void NotifyPlayer(Player* player, uint32 id, Args&&... args)
{
    if (g_testQuiet || !player || !player->GetSession())
        return;
    ChatHandler(player->GetSession()).PSendModuleSysMessage(MODULE_NAME, id, std::forward<Args>(args)...);
}

// Forward declarations (generated by split.ps1; definitions live in CoA.Challenges.*.cpp).
std::string ChallengeName(uint32 challengeID);
std::string ChallengeIcon(uint32 challengeID);
uint32 ChallengeLevelCount(uint32 challengeID);
std::string ChallengeBracket(uint32 challengeID, uint32 level);
std::string ChallengeIconTag(uint32 challengeID);
std::string ChatTimestamp();
char const* ClassToken(uint8 cls);
char const* ClassColorForToken(std::string const& token);
std::string PlayerNameLink(Player* player);
void AnnounceCompletion(Player* player, uint32 challengeID, uint32 level);
void SetDeathCause(Player* player, KillerKind kind, uint32 entry, std::string const& name, uint32 strId = 0);
void AnnounceFailure(Player* player, PendingFail const& fail);
void FlushFailureBroadcasts();
void AppendConfigString(WorldPacket& data, std::string const& key);
std::string HexDump(WorldPacket const& packet);
void EnsureTables();
void AppendClientConfig(AscensionClientConfig& config);
GameModeDef const* FindGameMode(std::string const& name);
char const* GameModeNameForBit(uint32 bit);
bool GameModesEnabled();
uint32 RealmGameModeMask();
void BuildGameModeBaseMap();
uint32 GameModeBaseForBit(uint32 bit);
std::unordered_map<uint32, uint32> GameModeBaseSnapshot();
uint32 PlayerToggleMaskFor(uint32 guid);
void ClearPlayerToggleBit(uint32 guid, uint32 bit);
uint32 LoadGameModeMask(uint32 guid);
bool CacheGenerationGuardEnabled();
std::vector<std::pair<uint32, uint32>> CachedCharChallenges(uint32 guid);
void ClearCharChallengeCache(uint32 guid);
struct ActiveChallengeRow
{
    uint32 challengeId = 0;
    uint32 level = 0;
    int32 hunger = 0;
    int32 thirst = 0;
};
std::vector<ActiveChallengeRow> LoadActiveChallengeRows(uint32 guid);
uint64 CharChallengeCacheGeneration();
void SeedCharChallengeCache(uint32 guid, uint64 generation, std::vector<ActiveChallengeRow> const& rows);
void PreloadLoginChallengeRows(uint32 guid);
std::vector<ActiveChallengeRow> TakeLoginChallengeRows(uint32 guid);
void ForgetLoginChallengeRows(uint32 guid);
uint32 CachedGameModeMask(uint32 guid);
void ClearGameModeMaskCache(uint32 guid);
void ApplyGameModeSpells(Player* player, uint32 oldMask, uint32 newMask);
void SaveGameModeMask(uint32 guid, uint32 mask);
void SendGameModeState(Player* player, uint32 mask);
void SendGameModeToggleResult(Player* player, std::string const& response);
void HandleToggleGameMode(Player* player, WorldPacket const& packet);
void ApplyGameModeToggle(Player* player, GameModeDef const* mode, bool enable);
uint32 LoadModeDeaths(uint32 guid, uint32 bit);
void SaveModeDeaths(uint32 guid, uint32 bit, uint32 deaths);
void ClearModeDeaths(uint32 guid, uint32 bit);
void TrackModeLives(Player* player, uint32 bit);
void UntrackModeLives(Player* player, uint32 bit);
void ReapplyGameModeBehavior(Player* player);
char const* ChallengeResponseString(uint32 code);
    std::vector<uint32> GetChallengeSpells(uint32 challengeID, uint32 level = 0);
    void ReapplyActiveSpells(Player* player);
    void ReapplyActiveSpells(Player* player, std::vector<ActiveChallengeRow> const& rows);
    void StripOrphanChallengeAuras(Player* player);
    std::vector<RewardDef> GetChallengeRewards(uint32 challengeID, uint32 level);
    void GrantChallengeRewards(Player* player, uint32 challengeID, uint32 level, bool firstItemReward,
        bool firstAchievement);
uint32 HungerFoodSpell();
uint32 HungerDrinkSpell();
void SetMeterAura(Player* player, uint32 spell, int32 value);
uint32 LivesTotal(uint32 challengeID);
bool IsHungerChallenge(uint32 challengeID);
void TakeHungerFlushLocked(uint32 guid, std::vector<HungerFlushRow>& out);
void CommitHungerFlush(uint32 guid, std::vector<HungerFlushRow> const& rows);
void TrackSurvivalist(Player* player);
void UntrackHunger(Player* player);
void WarnHunger(Player* player, uint32 kindId, int32 value);
void HungerUpdate(Player* player, uint32 diff);
void RefreshHungerTracking(Player* player);
void RefreshHungerTracking(Player* player, std::vector<ActiveChallengeRow> const& rows);
void RemoveHungerChallenge(Player* player, uint32 challengeID);
void SyncMeterAuras(Player* player);
bool IsFatigueChallenge(uint32 challengeID);
uint32 FatigueMax();
uint32 FatigueFillSeconds();
void PersistFatigue(uint32 guid, uint32 challengeId, int32 fatigue);
void StopFatigueBar(Player* player);
void SendFatigueBar(Player* player, int32 fatigue);
void TrackFatigue(Player* player, uint32 challengeID);
void ClearFatigue(Player* player);
void RefreshFatigueTracking(Player* player);
void RefreshFatigueTracking(Player* player, std::vector<ActiveChallengeRow> const& rows);
void TrackSpellbind(Player* player, uint32 challengeID);
void UntrackSpellbind(Player* player);
void RefreshSpellbindTracking(Player* player);
void TrackInvertedBreath(Player* player, uint32 challengeID);
void UntrackInvertedBreath(Player* player);
void RefreshInvertedBreathTracking(Player* player);
    void RefreshRegenTracking(Player* player);
    void UntrackRegen(Player* player);
    void FatigueUpdate(Player* player, uint32 diff);
    // HIGH_RISK_ONLY: aura that marks a character as participating in the
    // High Risk ruleset (applied by CoA). Conf-tunable.
    uint32 HighRiskAura();
    bool HighRiskActivationBlocked(Player* player);
    void RefreshHighRiskTracking(Player* player);
    void UntrackHighRisk(Player* player);
    bool HighRiskTracked(uint32 guid);
    // NO_CREATURE_LEVEL_SCALING / NO_QUEST_LEVEL_SCALING: the parts of level
    // scaling the active challenges switch off, as LocalLevelScaling's
    // ChallengeBlocks* mask (refreshed on login/activate/deactivate/complete/fail).
    void RefreshLevelScalingTracking(Player* player);
    void UntrackLevelScaling(Player* player);
    uint8 LevelScalingBlocks(Player const* player);
    // NO_NON_LOOTED_ITEMS ("Scavenger"): item-instance looted tracking.
    void RefreshLootedTracking(Player* player);
    void UntrackLootedItems(uint32 guid);
    bool ItemWasLooted(uint32 guid, uint32 itemGuid);
    // NO_HEALING_UNLESS_BANDAGING: the First Aid heal spells are the only
    // healing allowed by the rule.
    bool IsBandageSpell(SpellInfo const* spellInfo);
    // NO_GROUP_FOR_DUNGEONS: true when either player is inside a dungeon.
    bool GroupForDungeonsBlocked(Player* player, Player* other);
void SendActiveList(Player* player);
void SendActiveList(Player* player, std::vector<ActiveChallengeRow> const& rows);
void PushLoginState(Player* player);
void AppendFailureString(WorldPacket& data, std::string const& s);
void AppendFailureRecord(WorldPacket& data, std::string const& who, uint32 challengeID, uint32 level);
void SendFailureAdded(Player* player, uint32 challengeID, uint32 level);
void SendFailureList(Player* player);
void AppendCompletionEntry(WorldPacket& data, uint32 challengeID, uint32 level, std::string const& name, std::string const& race, std::string const& gender, std::string const& klass, uint32 startTime, uint32 completeTime);
void SendCompletionList(Player* player, uint32 challengeID, uint32 level);
void SendCompletionAdded(Player* player, uint32 challengeID, uint32 level);
void SendCompletedList(Player* player);
void AppendCriteriaEntry(WorldPacket& data, uint32 a, uint32 b, uint32 c, uint32 typeIdx,
    uint32 e, uint32 f, uint32 g, uint32 h, uint8 done);
std::array<uint32, 9> BuildCriteriaEntry(uint32 challengeID, uint32 level, uint32 typeIdx,
    Objective const& o, bool done);
uint32 RequirementIdFor(Player* player, uint32 challengeID, std::string const& key);
void SendRequirementDef(Player* player, uint32 id, std::string const& type,
    uint32 v1, uint32 v2, uint32 v3);
void SendCriteriaList(Player* player, std::vector<std::array<uint32, 9>> const& entries);
void SendCriteriaUpdated(Player* player, std::array<uint32, 9> const& e);
void SendCriteriaState(Player* player);
void SendCriteriaUpdatedForObjective(Player* player, uint32 challengeID, uint32 level,
    Objective const& o, bool done);
uint32 ActiveChallengeLevel(uint32 guid, uint32 challengeID);
bool ReadWireString(WorldPacket const& packet, uint32& off, std::string& out);
void SendTrialResult(Player* player, uint16 opcode, std::string const& trialID, std::string const& response);
std::string GenerateTrialId(uint32 guid);
void SendTrialList(Player* player);
void SendTrialData(Player* player);
void SendActiveTrial(Player* player, std::string const& trialID);
std::string GetActiveCustomTrial(uint32 guid);
void SetActiveCustomTrial(Player* player, std::string const& trialID);
uint32 TrialOwnerGuid(std::string const& trialID);
void EndActiveCustomTrialFor(Player* player, uint32 challengeID);
void AppendTrialCompletionEntry(WorldPacket& data, std::string const& trialID,
    std::string const& name, std::string const& race, std::string const& gender,
    std::string const& klass, uint32 startTime, uint32 completeTime);
void SendTrialCompletions(Player* player, std::string const& trialID);
void SendTrialCompletionAdded(Player* player, std::string const& trialID);
bool TryCompleteCustomTrial(Player* player, uint32 challengeID);
bool ActiveTrialDisplayFor(Player* player, uint32 challengeID, std::string& name, std::string& icon);
void HandleSaveTrial(Player* player, WorldPacket const& packet);
void HandleDeleteTrial(Player* player, WorldPacket const& packet);
void HandleActivateTrial(Player* player, WorldPacket const& packet);
void HandleDeactivateTrial(Player* player, WorldPacket const& packet);
void HandleRateTrial(Player* player, WorldPacket const& packet);
void SendSyncRequest(Player* player, uint32 timeoutMs, bool remove,
    std::vector<std::pair<uint32, uint32>> const& pairs, uint32 requesterGuid,
    bool rollbackOnDecline, std::vector<std::pair<uint32, uint32>> const& rollback);
void HandleSyncResponse(Player* player, WorldPacket const& packet);
void BroadcastChallengeSync(Player* player, uint32 challengeID, uint32 level, bool remove);
void SendChallengeSyncToGroup(Player* actor, uint32 timeoutMs, bool remove,
    std::vector<std::pair<uint32, uint32>> const& pairs, bool rollbackOnDecline,
    std::vector<std::pair<uint32, uint32>> const& rollback);
bool ChallengeRequiresParty(uint32 challengeID);
bool HasFailure(uint32 guid, uint32 challengeID);
bool HasAnyFailure(uint32 guid);
bool ActivationPermanentlyBlocked(uint32 guid);
bool HasCompletion(uint32 guid, uint32 challengeID);
bool HasCompletionLevel(uint32 guid, uint32 challengeID, uint32 level);
void SendDeathUpdate(Player* player, uint32 challengeID, uint32 level, uint32 deaths);
bool IsSharedFate(uint32 challengeID);
uint32 ExclusiveGroup(uint32 challengeID);
bool IsTrialChallenge(uint32 challengeID);
bool IsPrestigeChallenge(uint32 challengeID);
// Prestige state and its aura live in mod-coa-prestige (single owner).
// "Prestiged" is the client's C_Player:IsPrestiged() = HasAura(PRESTIGE_AURA).
// The experience bonus is applied here, from CoAPrestige::ExperienceBonusPercent.
constexpr uint32 COA_PRESTIGE_AURA = CoAPrestige::PRESTIGE_AURA;
bool IsPrestiged(Player* player);
uint32 RequiredGameMode(uint32 challengeID);
void RecomputeRequiredGameModes(Player* player);
void RecomputeRequiredGameModes(Player* player, std::vector<ActiveChallengeRow> const& rows);
uint32 RequiredGameEvent(uint32 challengeID);
bool NoRewards(uint32 challengeID);
bool ChallengeExists(uint32 challengeID);
uint32 ConflictingExclusiveChallenge(uint32 guid, uint32 challengeID, uint32& conflictId);
bool IsPermaDeath(uint32 challengeID);
bool HasPermaDeathFailure(Player* player);
uint32 ValidateChallenge(Player* player, uint32 challengeID, uint32 level);
void DoActivateChallenge(Player* player, uint32 challengeID, uint32 level);
uint32 ActivateChallenge(Player* player, uint32 challengeID, uint32 level);
bool AdventureModeChangeBlocked(Player* player);
void DeactivateChallenge(Player* player, uint32 challengeID);
bool RuleListContains(std::string const& list, std::string const& rule);
bool PlayerHasRule(Player* player, char const* rule);
void LoadChallengesEnabled();
bool ChallengesEnabled();
bool OutsideInteractionGateEnabled();
uint32 ActiveChallengeWithRule(Player* player, char const* rule, uint32& level);
std::set<uint32> ActiveChallenges(uint32 guid);
bool HasActiveTrial(uint32 guid);
void SetConditionFlag(uint32 guid, char const* flag);
bool HasConditionFlag(uint32 guid, char const* flag);
void ClearConditionFlag(uint32 guid, std::string const& flag);
void ResetConditionFlags(uint32 guid);
void ForgetConditionFlags(uint32 guid);
uint32 FreeInventorySlots(Player* player);
std::vector<ConditionState> EvaluateConditions(Player* player, uint32 challengeID);
std::vector<ConditionState> EvaluateConditionsFor(Player* player, uint32 challengeID,
    std::string const& conds, bool injectOutside);
std::string CheckActivationConditions(Player* player, uint32 challengeID);
bool IsPristine(Player* player, uint32 challengeID);
bool RequirementsMet(uint32 guid, uint32 challengeID);
void CompleteAtLevelCap(Player* player);
int QuestColor(uint32 questLevel, uint32 playerLevel);
uint32 NextGatedLevel(Player* player);
void MarkObjectives(Player* player, char const* type, uint32 eventValue);
uint32 ObjectiveFailLabelId(std::string const& type);
bool CheckObjectiveLevels(Player* player);
// killerSource is the guid whose death carries the killer info. causeKind (with
// causeEntry/causeName) lets a rule failure name its own cause (e.g. the beast a
// FAILABLE_NO_KILL_BEASTS trial forbids) instead of "killed by Unknown".
void FailChallenge(Player* player, uint32 challengeID, uint32 level, uint32 deaths,
    ObjectGuid const& killerSource = ObjectGuid::Empty,
    KillerKind causeKind = KillerKind::Unknown, uint32 causeEntry = 0, std::string causeName = "");
void FailSharedFate(Player* dead, uint32 challengeID);
void FailSharedFateHolders(Group* group, ObjectGuid extraGuid);
void HandlePlayerDeath(Player* player);
uint32 CraftedItemRarity(SkillLineAbilityEntry const* ability);
void GrantProfessionXP(Player* member, uint32 rarityMult);
Player* GetPlayerOwner(Creature* creature);
void ApplyActiveChallengeSpellsToCreature(Player* player, Creature* creature);
} // namespace CoAChallenges

#endif // COA_CHALLENGES_REVIEW_H
