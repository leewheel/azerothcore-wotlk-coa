/*
 * mod-ascension-compat
 *
 * Public, read-only resource metadata & live-state query API.
 *
 * AscensionCustomResourceData.h's tables (ResourceDisplays/ResourceGainRules/ResourceCostRules/
 * NativePowerGainRules) describe *most* of each class's real resource behavior, but several
 * classes' true gain/spend/cap logic lives in hand-written per-class code and is NOT fully
 * reflected in those tables. This header is the single place other modules (bot AI, tooling)
 * should query real resource state and ability resource requirements from -- never re-derive
 * rules from the raw tables or from a class's own hardcoded constants independently. Every
 * function here is read-only: none of them mutate player state or change any gameplay behavior.
 *
 * (Ported from the upstream mod-ascension-compat header; the implementation lives alongside
 * this file in AscensionResourceQuery.cpp. By leewheel 2026年10月27日)
 */

#ifndef ASCENSION_RESOURCE_QUERY_H
#define ASCENSION_RESOURCE_QUERY_H

#include "AscensionCustomResourceData.h"
#include "Define.h"
#include <vector>

class Player;

namespace AscensionCompatData
{
    // One resource "channel" a class can have -- either a native Blizzard power bar (identified
    // by Powers enum value) or a custom stacking aura. A class can have zero, one, or several
    // simultaneously.
    struct ResourceChannel
    {
        bool IsNative = false;
        uint8 NativePowerType = 0;  // valid when IsNative (a Powers enum value)
        uint32 AuraSpellId = 0;     // valid when !IsNative
        char const* Name = "";
    };

    // Every resource channel `classId` actually has. Built from ResourceDisplays plus a small,
    // manually-curated set of additions for resources that exist in the class's own C++ code but
    // have no ResourceDisplays row at all.
    std::vector<ResourceChannel> const& GetResourceChannels(uint8 classId);

    struct ResourceState
    {
        uint32 Current = 0;
        uint32 Maximum = 0;
        bool MaximumKnown = false;
    };

    // Current/maximum for one custom aura-stack resource, matching what that class's own
    // gain/spend code enforces. Returns MaximumKnown=false (with Current still valid) when no
    // display row exists -- callers must not invent a percentage in that case.
    ResourceState QueryAuraResourceState(Player* player, uint32 resourceSpellId);

    // One custom-resource requirement a specific already-resolved ability has (classId +
    // resolvedSpellId -- use the resolved rank). Resolved from ResourceCostRules (first matching
    // row wins, exactly mirroring AscensionResourceService::CheckCast's own first-match-then-break
    // semantics). Returns an empty vector when the ability has no custom resource requirement at
    // all -- callers must still separately check the spell's native DBC power cost via
    // SpellInfo::CalcPowerCost. Conditional requirements (RequiredAuraSpellId/ForbiddenAuraSpellId)
    // are always 0 in the table-driven rows; the caller evaluates them against the real player.
    struct ResourceRequirement
    {
        uint32 ResourceSpellId = 0;
        uint32 Amount = 0;
        ResourceConsumption Consumption = ResourceConsumption::None;
        uint32 PreserveCostAuraSpellId = 0;
        uint8 PreserveCostChancePercent = 0;
        uint32 RequiredAuraSpellId = 0;   // requirement only active while this aura IS present
        uint32 ForbiddenAuraSpellId = 0;  // requirement only active while this aura IS ABSENT
    };
    std::vector<ResourceRequirement> QueryAbilityResourceRequirements(uint8 classId, uint32 resolvedSpellId);

    // A pure aura-presence/absence cast gate with no numeric resource economy behind it.
    // Table-driven build: returns the gates declared by the class data; no hardcoded extras.
    struct AuraGate
    {
        uint32 AuraSpellId = 0;
        bool RequireAbsent = true;  // true: blocks the cast while the aura IS present
    };
    std::vector<AuraGate> QueryAbilityAuraGates(uint8 classId, uint32 resolvedSpellId);

    // Necromancer's minion-capacity economy (classId 23) is an active-summon counter, not an
    // aura-stack or native power bar. Both call straight through to AscensionNecromancer's own
    // real Capacity/Used/Cost functions (never reimplemented here).
    struct MinionCapacityState
    {
        uint32 Current = 0;  // currently-used capacity (live minion count)
        uint32 Maximum = 0;
    };
    MinionCapacityState QueryMinionCapacityState(Player* player);
    uint32 QueryMinionCapacityCost(Player* player, uint32 resolvedSpellId);

    // One resource this ability potentially generates (classId + resolvedSpellId), resolved from
    // ResourceGainRules (custom aura, IsNative=false) and NativePowerGainRules (native power bar,
    // IsNative=true), matched by spell id range the same way the runtime event handlers do.
    struct ResourceGain
    {
        bool IsNative = false;
        uint32 ResourceSpellId = 0;  // valid when !IsNative
        uint8 NativePowerType = 0;   // valid when IsNative
        int32 Amount = 0;
        ResourceGainEvent Event = ResourceGainEvent::Cast;
        uint32 RequiredAuraSpellId = 0;
        uint32 ForbiddenAuraSpellId = 0;
        uint8 ChancePercent = 100;
    };
    std::vector<ResourceGain> QueryAbilityResourceGains(uint8 classId, uint32 resolvedSpellId);
}

#endif // ASCENSION_RESOURCE_QUERY_H
