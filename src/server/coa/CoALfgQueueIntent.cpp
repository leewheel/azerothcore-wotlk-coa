/*
 * CoA core glue for mod-coa-playerbots' Dungeon Finder auto-fill.
 *
 * mod-coa-playerbots gates its fill logic on the queue policy being
 * LfgCompositionMode::BOT_FILL (BotLfgFill.cpp), resolved through
 * ScriptMgr::OnResolveLfgQueuePolicy. The upstream corfirean checkout consumes that policy in
 * LFGMgr too, but its setter script was never published in the core repository, so without a
 * handler here the policy would stay MATCHMAKING forever and CoaBots.LfgFill.Enable would do
 * nothing. This file fills that gap: a player whose group is not yet a full five (solo or a
 * partial group) is queued with bot-fill intent, which is exactly the scenario the module's
 * own config documents ("a solo player queuing for a dungeon is automatically joined by
 * bots"). Grouped-full players keep plain MATCHMAKING, and the module re-checks its own
 * enable switch, raid scope and role math before spawning anything.
 *
 * By leewheel 2026年10月27日
 */

#include "GlobalScript.h"
#include "Group.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "ScriptMgr.h"

namespace
{
class coa_lfg_queue_intent : public GlobalScript
{
public:
    coa_lfg_queue_intent()
        : GlobalScript("coa_lfg_queue_intent", { GLOBALHOOK_ON_RESOLVE_LFG_QUEUE_POLICY }) { }

    void OnResolveLfgQueuePolicy(ObjectGuid const& guid, lfg::LfgQueuePolicy& policy) override
    {
        Player* player = ObjectAccessor::FindPlayer(guid);
        if (!player)
            return;

        // A group of five already covers every role the dungeon needs: nothing for bots to do,
        // so it keeps the plain matchmaking intent. Anything shorter (solo included) may be
        // topped off by the fill provider.
        if (Group* group = player->GetGroup())
        {
            if (group->GetMembersCount() >= 5)
                return;
        }

        policy.compositionMode = lfg::LfgCompositionMode::BOT_FILL;
    }
};
}

void AddSC_coa_lfg_queue_intent()
{
    new coa_lfg_queue_intent();
}
