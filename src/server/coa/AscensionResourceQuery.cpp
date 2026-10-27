/*
 * mod-ascension-compat (ported implementation)
 *
 * Table-driven build: every function below reads AscensionCustomResourceData.h's constexpr
 * tables or calls the owning class's own live functions. The handful of hardcoded per-class
 * special cases the upstream .cpp carried (SunCleric's cap, Cultist/Venomancer/Reaper gates)
 * are not ported yet -- those paths return the safe table value or an empty vector, which the
 * bot AI treats as "no extra constraint" rather than inventing one.
 *
 * By leewheel 2026年10月27日
 */

#include "AscensionResourceQuery.h"
#include "AscensionNecromancer.h"
#include "Player.h"
#include <unordered_map>

namespace AscensionCompatData
{
namespace
{
    // Every resource channel per class, built once from ResourceDisplays.
    std::unordered_map<uint8, std::vector<ResourceChannel>> BuildChannels()
    {
        std::unordered_map<uint8, std::vector<ResourceChannel>> channels;
        for (ResourceDisplay const& display : ResourceDisplays)
            channels[display.ClassId].push_back({ false, 0, display.SpellId, display.Name });
        return channels;
    }
}

// Every custom aura-stack resource channel `classId` has, straight from ResourceDisplays.
// Native power bars are not listed here -- callers read them via Player::getPowerType()/GetPower().
std::vector<ResourceChannel> const& GetResourceChannels(uint8 classId)
{
    static std::unordered_map<uint8, std::vector<ResourceChannel>> const channels = BuildChannels();
    static std::vector<ResourceChannel> const empty;
    auto it = channels.find(classId);
    return it != channels.end() ? it->second : empty;
}

// Live current/maximum for one custom aura-stack resource. The maximum comes from the class's
// ResourceDisplays row; MaximumKnown=false when there is no row (or the row carries no cap),
// so callers fall back to an absolute count instead of synthesizing a percentage.
ResourceState QueryAuraResourceState(Player* player, uint32 resourceSpellId)
{
    ResourceState state;
    if (!player || !resourceSpellId)
        return state;

    state.Current = player->GetAuraCount(resourceSpellId);

    for (ResourceDisplay const& display : ResourceDisplays)
    {
        if (display.SpellId == resourceSpellId)
        {
            state.Maximum = display.DisplayMaximum;
            state.MaximumKnown = display.DisplayMaximum > 0;
            break;
        }
    }
    return state;
}

// First ResourceCostRules row whose [FirstSpellId, LastSpellId] range contains the resolved
// spell -- first match wins, mirroring AscensionResourceService::CheckCast's own loop.
std::vector<ResourceRequirement> QueryAbilityResourceRequirements(uint8 classId, uint32 resolvedSpellId)
{
    std::vector<ResourceRequirement> result;
    if (!resolvedSpellId)
        return result;

    for (ResourceCostRule const& rule : ResourceCostRules)
    {
        if (rule.ClassId != classId || resolvedSpellId < rule.FirstSpellId || resolvedSpellId > rule.LastSpellId)
            continue;

        ResourceRequirement requirement;
        requirement.ResourceSpellId = rule.ResourceSpellId;
        requirement.Amount = rule.Amount;
        requirement.Consumption = rule.Consumption;
        requirement.PreserveCostAuraSpellId = rule.PreserveCostAuraSpellId;
        requirement.PreserveCostChancePercent = rule.PreserveCostChancePercent;
        result.push_back(requirement);
        break; // first matching row wins
    }
    return result;
}

// Aura-presence gates live in the upstream's hardcoded per-class audit, which this port does
// not carry yet: an empty vector tells the caller there is no extra gate beyond the numeric
// requirements above.
std::vector<AuraGate> QueryAbilityAuraGates(uint8 /*classId*/, uint32 /*resolvedSpellId*/)
{
    return {};
}

// Straight through to AscensionNecromancer's own live counters (never reimplemented here).
MinionCapacityState QueryMinionCapacityState(Player* player)
{
    MinionCapacityState state;
    if (!player)
        return state;

    state.Current = AscensionNecromancer::Used(player);
    state.Maximum = AscensionNecromancer::Capacity(player);
    return state;
}

uint32 QueryMinionCapacityCost(Player* player, uint32 resolvedSpellId)
{
    if (!player || !resolvedSpellId)
        return 0;

    return AscensionNecromancer::Cost(player, resolvedSpellId);
}

// Custom-aura gains from ResourceGainRules plus native-bar gains from NativePowerGainRules,
// both matched by spell id range the same way the runtime event handlers do.
std::vector<ResourceGain> QueryAbilityResourceGains(uint8 classId, uint32 resolvedSpellId)
{
    std::vector<ResourceGain> result;
    if (!resolvedSpellId)
        return result;

    for (ResourceGainRule const& rule : ResourceGainRules)
    {
        if (rule.ClassId != classId || resolvedSpellId < rule.FirstSpellId || resolvedSpellId > rule.LastSpellId)
            continue;

        ResourceGain gain;
        gain.IsNative = false;
        gain.ResourceSpellId = rule.ResourceSpellId;
        gain.Amount = rule.Amount;
        gain.Event = rule.Event;
        gain.RequiredAuraSpellId = rule.RequiredAuraSpellId;
        gain.ForbiddenAuraSpellId = rule.ForbiddenAuraSpellId;
        gain.ChancePercent = rule.ChancePercent;
        result.push_back(gain);
    }

    for (NativePowerGainRule const& rule : NativePowerGainRules)
    {
        if (rule.ClassId != classId || resolvedSpellId < rule.FirstSpellId || resolvedSpellId > rule.LastSpellId)
            continue;

        ResourceGain gain;
        gain.IsNative = true;
        gain.NativePowerType = rule.PowerType;
        gain.Amount = rule.InternalAmount;
        gain.Event = rule.Event;
        gain.RequiredAuraSpellId = rule.RequiredAuraSpellId;
        gain.ForbiddenAuraSpellId = rule.ForbiddenAuraSpellId;
        result.push_back(gain);
    }
    return result;
}
} // namespace AscensionCompatData
