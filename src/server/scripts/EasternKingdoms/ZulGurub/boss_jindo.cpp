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

#include "CreatureScript.h"
#include "ScriptedCreature.h"
#include "SpellScript.h"
#include "SpellScriptLoader.h"
#include "TaskScheduler.h"
#include "zulgurub.h"

enum Say
{
    SAY_AGGRO                       = 1
};

enum Spells
{
    SPELL_BRAIN_WASH_TOTEM          = 24262,
    SPELL_POWERFULL_HEALING_WARD    = 24309,
    SPELL_HEX                       = 17172,
    SPELL_DELUSIONS_OF_JINDO        = 24306,
    SPELL_SUMMON_SHADE_OF_JINDO     = 24308,
    SPELL_BANISH                    = 24466,

    //Healing Ward Spell
    SPELL_HEAL                      = 24311,

    //Shade of Jindo Spell
    SPELL_SHADE_OF_JINDO_PASSIVE    = 24307,
    SPELL_SHADE_OF_JINDO_VISUAL     = 24313,
    SPELL_SHADOW_SHOCK              = 19460,
    SPELL_RANDOM_AGGRO              = 23878
};

enum Events
{
    EVENT_BRAIN_WASH_TOTEM          = 1,
    EVENT_POWERFULL_HEALING_WARD    = 2,
    EVENT_HEX                       = 3,
    EVENT_DELUSIONS_OF_JINDO        = 4,
    EVENT_TELEPORT                  = 5
};

struct boss_jindo : public BossAI
{
    boss_jindo(Creature* creature) : BossAI(creature, DATA_JINDO) { }

    void JustEngagedWith(Unit* who) override
    {
        BossAI::JustEngagedWith(who);
        events.ScheduleEvent(EVENT_BRAIN_WASH_TOTEM, 20s);
        events.ScheduleEvent(EVENT_POWERFULL_HEALING_WARD, 16s);
        events.ScheduleEvent(EVENT_HEX, 8s);
        events.ScheduleEvent(EVENT_DELUSIONS_OF_JINDO, 10s);
        events.ScheduleEvent(EVENT_TELEPORT, 5s);

        Talk(SAY_AGGRO);

        me->SetUInt32Value(UNIT_NPC_EMOTESTATE, EMOTE_STATE_NONE);
        _scheduler.CancelAll();
    }

    void JustSummoned(Creature* summon) override
    {
        BossAI::JustSummoned(summon);

        switch (summon->GetEntry())
        {
            case NPC_BRAIN_WASH_TOTEM:
                summon->SetReactState(REACT_PASSIVE);
                if (Unit* target = SelectTarget(SelectTargetMethod::Random, me->GetThreatMgr().GetThreatListSize() > 1 ? 1 : 0))
                {
                    summon->CastSpell(target, summon->m_spells[0], true);
                }
                break;
            default:
                break;
        }
    }

    void EnterEvadeMode(EvadeReason evadeReason) override
    {
        if (CreatureAI::_EnterEvadeMode(evadeReason))
        {
            Reset();
            me->SetUInt32Value(UNIT_NPC_EMOTESTATE, EMOTE_STATE_DANCE);

            _scheduler.Schedule(4s, [this](TaskContext /*context*/)
            {
                me->SetUInt32Value(UNIT_NPC_EMOTESTATE, EMOTE_STATE_NONE);
                me->AddUnitState(UNIT_STATE_EVADE);
                me->GetMotionMaster()->MoveTargetedHome();
            });
        }
    }

    void UpdateAI(uint32 diff) override
    {
        _scheduler.Update(diff);

        if (!UpdateVictim())
            return;

        events.Update(diff);

        if (me->HasUnitState(UNIT_STATE_CASTING))
            return;

        while (uint32 eventId = events.ExecuteEvent())
        {
            switch (eventId)
            {
            case EVENT_BRAIN_WASH_TOTEM:
                DoCastSelf(SPELL_BRAIN_WASH_TOTEM);
                events.ScheduleEvent(EVENT_BRAIN_WASH_TOTEM, 18s, 26s);
                break;
            case EVENT_POWERFULL_HEALING_WARD:
                DoCastSelf(SPELL_POWERFULL_HEALING_WARD, true);
                events.ScheduleEvent(EVENT_POWERFULL_HEALING_WARD, 14s, 20s);
                break;
            case EVENT_HEX:
                if (me->GetThreatMgr().GetThreatListSize() > 1)
                    DoCastVictim(SPELL_HEX, true);
                events.ScheduleEvent(EVENT_HEX, 12s, 20s);
                break;
            case EVENT_DELUSIONS_OF_JINDO:
                DoCastRandomTarget(SPELL_DELUSIONS_OF_JINDO);
                events.ScheduleEvent(EVENT_DELUSIONS_OF_JINDO, 4s, 12s);
                break;
            case EVENT_TELEPORT:
                DoCastRandomTarget(SPELL_BANISH);
                events.ScheduleEvent(EVENT_TELEPORT, 15s, 23s);
                break;
            default:
                break;
            }
        }

        DoMeleeAttackIfReady();
    }

private:
    TaskScheduler _scheduler;
};

//Healing Ward
struct npc_healing_ward : public ScriptedAI
{
    npc_healing_ward(Creature* creature) : ScriptedAI(creature)
    {
        _instance = creature->GetInstanceScript();
    }

    void Reset() override
    {
        _scheduler.CancelAll();
    }

    void JustEngagedWith(Unit* /*who*/) override
    {
        _scheduler.
            Schedule(2s, [this](TaskContext context)
            {
                Unit* pJindo = ObjectAccessor::GetUnit(*me, _instance->GetGuidData(DATA_JINDO));
                if (pJindo)
                    DoCast(pJindo, SPELL_HEAL);
                context.Repeat(3s);
            });
    }

    void UpdateAI(uint32 diff) override
    {
        _scheduler.Update(diff, [this]
            {
                DoMeleeAttackIfReady();
            });
    }

private:
    InstanceScript* _instance;
    TaskScheduler _scheduler;
};

//Shade of Jindo
struct npc_shade_of_jindo : public ScriptedAI
{
    npc_shade_of_jindo(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(WorldObject* /*summoner*/) override
    {
        DoZoneInCombat();
        DoCastSelf(SPELL_SHADE_OF_JINDO_PASSIVE, true);
        DoCastSelf(SPELL_SHADE_OF_JINDO_VISUAL, true);
        DoCastAOE(SPELL_RANDOM_AGGRO, true);
    }

    void Reset() override
    {
        _scheduler.CancelAll();

        _scheduler.
            Schedule(1s, [this](TaskContext context)
            {
                DoCastAOE(SPELL_RANDOM_AGGRO, true);
                context.Repeat();
            });
    }

    void JustEngagedWith(Unit* /*who*/) override
    {
        _scheduler.
            Schedule(1s, [this](TaskContext context)
            {
                DoCastVictim(SPELL_SHADOW_SHOCK);
                context.Repeat(2s);
            });
    }

    void UpdateAI(uint32 diff) override
    {
        _scheduler.Update(diff, [this]
            {
                DoMeleeAttackIfReady();
            });
    }

private:
    TaskScheduler _scheduler;
};

class spell_random_aggro : public SpellScript
{
    PrepareSpellScript(spell_random_aggro);

    void HandleOnHit()
    {
        Unit* caster = GetCaster();
        Unit* target = GetHitUnit();
        if (!caster || !target || !caster->GetAI())
            return;

        caster->GetAI()->AttackStart(target);
    }

    void Register() override
    {
        OnHit += SpellHitFn(spell_random_aggro::HandleOnHit);
    }
};

class spell_delusions_of_jindo : public SpellScript
{
    PrepareSpellScript(spell_delusions_of_jindo);

    bool Validate(SpellInfo const* /*spellInfo*/) override
    {
        return ValidateSpellInfo({ SPELL_SUMMON_SHADE_OF_JINDO });
    }

    void HandleOnHit()
    {
        Unit* caster = GetCaster();
        if (caster)
            caster->CastSpell(caster, SPELL_SUMMON_SHADE_OF_JINDO, true);
    }

    void Register() override
    {
        OnHit += SpellHitFn(spell_delusions_of_jindo::HandleOnHit);
    }
};

//By leewheel 2026年11月05日 上游 rev_20261104_01 已把 14987 / 15112 两个图腾改由模块脚本
// npc_jindo_coa_totem 接管，经典 npc_brain_wash_totem 不再有 DB 引用（否则启动报
// "Script named 'npc_brain_wash_totem' is not assigned in the database."），连同结构体一并移除。
//End By leewheel

void AddSC_boss_jindo()
{
    //By leewheel 2026年10月26日 经典脚本死注册注销：DB 已换用 *_coa/新版脚本，此注册无 DB 引用
    //RegisterZulGurubCreatureAI(boss_jindo);
    //By leewheel 2026年11月1日 上游 rev_20261025_92 已把 14987 改为 NullCreatureAI + 法术脚本
    //（spell_jindo_coa_healing_stream），经典 npc_healing_ward 无 DB 引用，注销以消 Errors.log 告警
    //RegisterZulGurubCreatureAI(npc_healing_ward);
    //By leewheel 2026年11月9日 经典脚本死注册注销：14986 Shade of Jin'do 的 ScriptName 已是
    //npc_shade_of_jindo_coa（COA 版接管），经典 npc_shade_of_jindo 无任何 DB 引用，
    //每启动都会在 Errors.log 打一条 "Script named 'npc_shade_of_jindo' is not assigned in the database"。
    //RegisterZulGurubCreatureAI(npc_shade_of_jindo);
    RegisterSpellScript(spell_random_aggro);
    RegisterSpellScript(spell_delusions_of_jindo);
}
