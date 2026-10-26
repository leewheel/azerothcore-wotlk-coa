/*
 * The Guardian of Time.
 *
 * His menu as live Ascension served it on Season 10: General Goods, Heirlooms (level 60), Upgrade Worldforged
 * and, for free-pick Heroes only, Mystic Scrolls with one store per class. Freepick and Warcraft Reborn realms
 * also sell the Mystic Enchanting altars. Warcraft Reborn characters get their own Mystic Scrolls stores, one per
 * original class, holding the enchants live Bronzebeard players found in the world. Every store is a vendor list
 * held by an unspawned creature (9781000 and on) that SendListInventory opens from the Guardian himself. The
 * Worldforged upgrades send SMSG_OPEN_CUSTOM_STORE and the client opens its own RPGItemStore window.
 *
 * Where he stood is not recovered. The client keeps the call board points of
 * interest, but only X and Y, so any spawn written here would be a guess. He is
 * created without one; place him with `.npc add 9780012`.
 */

#include "WorldforgedUpgrades.h"

#include "AscensionAccountProgress.h"
#include "AscensionFreepick.h"
#include "AscensionWarcraftReborn.h"
#include "Chat.h"
#include "Config.h"
#include "Creature.h"
#include "DBCStores.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "ScriptedGossip.h"
#include "WorldSession.h"

#include <array>

namespace Worldforged
{
    void OpenStore(Player* player, uint32 store);
}

namespace
{
    constexpr uint32 INVISIBLE_GOSSIP_ICON = 34;
    constexpr uint8 HEIRLOOM_LEVEL = 60;
    constexpr uint32 GENERAL_GOODS = 9781000;
    constexpr uint32 HEIRLOOMS = 9781001;
    constexpr uint32 ALTARS = 9781012;

    enum GossipAction
    {
        ACTION_WEAPONS = GOSSIP_ACTION_INFO_DEF + 1,
        ACTION_ARMOUR = GOSSIP_ACTION_INFO_DEF + 2,
        ACTION_GENERAL_GOODS = GOSSIP_ACTION_INFO_DEF + 3,
        ACTION_HEIRLOOMS = GOSSIP_ACTION_INFO_DEF + 4,
        ACTION_MYSTIC_SCROLLS = GOSSIP_ACTION_INFO_DEF + 5,
        ACTION_ALTARS = GOSSIP_ACTION_INFO_DEF + 6,
        ACTION_MYSTIC_SCROLL_CLASS = GOSSIP_ACTION_INFO_DEF + 100,
        ACTION_REBORN_SCROLL_CLASS = GOSSIP_ACTION_INFO_DEF + 200,
    };

    struct ScrollStore
    {
        char const* Icon;
        uint8 ClassId;   ///< ChrClasses ClassID; the label comes from the DBC
        uint32 Vendor;
    };

    // The class name is NOT stored here: it is read from ChrClasses.dbc in the
    // player's own locale, so one row per store is enough for every language.
    constexpr std::array<ScrollStore, 10> SCROLL_STORES = { {
        { "Ability_Rogue_Ambush",           1, 9781002 }, // Warrior
        { "Ability_ThunderBolt",            2, 9781003 }, // Paladin
        { "Ability_MeleeDamage",            3, 9781004 }, // Hunter
        { "Spell_Shadow_RitualOfSacrifice", 4, 9781005 }, // Rogue
        { "Spell_Holy_HolySmite",           5, 9781006 }, // Priest
        { "Spell_DeathKnight_IceTouch",     6, 9781007 }, // Death Knight
        { "Spell_Nature_Lightning",         7, 9781008 }, // Shaman
        { "Spell_Fire_FlameBolt",           8, 9781009 }, // Mage
        { "Spell_Shadow_ShadowBolt",        9, 9781010 }, // Warlock
        { "Spell_Nature_AbolishMagic",     11, 9781011 }, // Druid
    } };

    constexpr std::array<ScrollStore, 9> REBORN_SCROLL_STORES = { {
        { "Ability_Rogue_Ambush",           1, 9781013 }, // Warrior
        { "Ability_ThunderBolt",            2, 9781014 }, // Paladin
        { "Ability_MeleeDamage",            3, 9781015 }, // Hunter
        { "Spell_Shadow_RitualOfSacrifice", 4, 9781016 }, // Rogue
        { "Spell_Holy_HolySmite",           5, 9781017 }, // Priest
        { "Spell_Nature_Lightning",         7, 9781018 }, // Shaman
        { "Spell_Fire_FlameBolt",           8, 9781019 }, // Mage
        { "Spell_Shadow_ShadowBolt",        9, 9781020 }, // Warlock
        { "Spell_Nature_AbolishMagic",     11, 9781021 }, // Druid
    } };

    std::string IconText(std::string const& icon, std::string const& text)
    {
        return "|TInterface/ICONS/" + icon + ":30:30:-18:0|t|r" + text;
    }

    void AddOption(Player* player, std::string const& icon, std::string const& text, uint32 action)
    {
        AddGossipItemFor(player, INVISIBLE_GOSSIP_ICON, IconText(icon, text), GOSSIP_SENDER_MAIN, action);
    }

    /// An option whose label is a row of `module_string`, shown in the
    /// player's own locale.
    void AddLocalizedOption(Player* player, std::string const& icon, uint32 stringId, uint32 action)
    {
        ChatHandler handler(player->GetSession());
        AddOption(player, icon, handler.GetModuleString(Worldforged::MODULE_NAME, stringId)->c_str(), action);
    }

    /// The class name in the player's own locale, straight from ChrClasses.dbc.
    /// An empty string means the DBC knows the class under no name at all,
    /// which has not been seen.
    std::string LocalizedClassName(Player* player, uint8 classId)
    {
        if (ChrClassesEntry const* cls = sChrClassesStore.LookupEntry(classId))
        {
            int32 const locale = player->GetSession()->GetSessionDbLocaleIndex();
            if (locale >= 0 && size_t(locale) < 16 && cls->name[locale])
                return cls->name[locale];
            if (cls->name[LOCALE_enUS])
                return cls->name[LOCALE_enUS];
        }
        return {};
    }

    bool SellsScrolls(Player const* player)
    {
        return AscensionFreepick::IsFreepickHero(player) || AscensionWarcraftReborn::IsRebornCharacter(player);
    }
    //By leewheel 2026年10月26日 修复合并残留：删除此处多余的“}”，匿名命名空间统一在 SendScrollMenu 之后（162行）关闭

    bool SellsAltars()
    {
        return AscensionFreepick::RealmOffersMysticAltars();
    }

    void SendMainMenu(Player* player, Creature* creature)
    {
        ClearGossipMenuFor(player);
        AddLocalizedOption(player, "Inv_Misc_Coin_02", Worldforged::LANG_WORLDFORGED_MENU_GENERAL_GOODS, ACTION_GENERAL_GOODS);
        AddLocalizedOption(player, "inv_axe_09", Worldforged::LANG_WORLDFORGED_MENU_HEIRLOOMS, ACTION_HEIRLOOMS);
        if (SellsScrolls(player))
            AddLocalizedOption(player, "inv_misc_scrollunrolled01c", Worldforged::LANG_WORLDFORGED_MENU_MYSTIC_SCROLLS, ACTION_MYSTIC_SCROLLS);
        if (SellsAltars())
            AddLocalizedOption(player, "ability_racial_arcaneaffinity", Worldforged::LANG_WORLDFORGED_MENU_ALTARS, ACTION_ALTARS);
        AddLocalizedOption(player, "Mail_GMIcon", Worldforged::LANG_WORLDFORGED_MENU_UPGRADE_WEAPONS, ACTION_WEAPONS);
        AddLocalizedOption(player, "Mail_GMIcon", Worldforged::LANG_WORLDFORGED_MENU_UPGRADE_ARMOUR, ACTION_ARMOUR);
        SendGossipMenuFor(player, Worldforged::GUARDIAN_ENTRY, creature->GetGUID());
    }

    void SendScrollMenu(Player* player, Creature* creature)
    {
        ClearGossipMenuFor(player);
        if (AscensionWarcraftReborn::IsRebornCharacter(player))
            for (uint32 index = 0; index < REBORN_SCROLL_STORES.size(); ++index)
                AddOption(player, REBORN_SCROLL_STORES[index].Icon, LocalizedClassName(player, REBORN_SCROLL_STORES[index].ClassId),
                    ACTION_REBORN_SCROLL_CLASS + index);
        else
            for (uint32 index = 0; index < SCROLL_STORES.size(); ++index)
                AddOption(player, SCROLL_STORES[index].Icon, LocalizedClassName(player, SCROLL_STORES[index].ClassId),
                    ACTION_MYSTIC_SCROLL_CLASS + index);
        SendGossipMenuFor(player, Worldforged::GUARDIAN_ENTRY, creature->GetGUID());
    }
}

class npc_worldforged_guardian : public CreatureScript
{
public:
    npc_worldforged_guardian() : CreatureScript("npc_worldforged_guardian") { }

    bool OnGossipHello(Player* player, Creature* creature) override
    {
        SendMainMenu(player, creature);
        return true;
    }

    bool OnGossipSelect(Player* player, Creature* creature, uint32 /*sender*/, uint32 action) override
    {
        switch (action)
        {
            case ACTION_WEAPONS:
                CloseGossipMenuFor(player);
                Worldforged::OpenStore(player, Worldforged::STORE_WEAPONS);
                return true;
            case ACTION_ARMOUR:
                CloseGossipMenuFor(player);
                Worldforged::OpenStore(player, Worldforged::STORE_ARMOUR);
                return true;
            case ACTION_GENERAL_GOODS:
                CloseGossipMenuFor(player);
                player->GetSession()->SendListInventory(creature->GetGUID(), GENERAL_GOODS);
                return true;
            case ACTION_HEIRLOOMS:
                if (!AscensionAccountProgress::HasLevelOrPrestige(player, HEIRLOOM_LEVEL))
                {
                    ChatHandler(player->GetSession()).PSendModuleSysMessage(
                        Worldforged::MODULE_NAME, Worldforged::LANG_WORLDFORGED_HEIRLOOM_LEVEL_REQUIRED);
                    SendMainMenu(player, creature);
                    return true;
                }
                CloseGossipMenuFor(player);
                player->GetSession()->SendListInventory(creature->GetGUID(), HEIRLOOMS);
                return true;
            case ACTION_ALTARS:
                if (!SellsAltars())
                    break;
                CloseGossipMenuFor(player);
                player->GetSession()->SendListInventory(creature->GetGUID(), ALTARS);
                return true;
            case ACTION_MYSTIC_SCROLLS:
                if (!SellsScrolls(player))
                    break;
                SendScrollMenu(player, creature);
                return true;
            default:
                break;
        }

        uint32 const store = action - ACTION_MYSTIC_SCROLL_CLASS;
        if (action >= ACTION_MYSTIC_SCROLL_CLASS && store < SCROLL_STORES.size() &&
            AscensionFreepick::IsFreepickHero(player))
        {
            CloseGossipMenuFor(player);
            player->GetSession()->SendListInventory(creature->GetGUID(), SCROLL_STORES[store].Vendor);
            return true;
        }
        uint32 const rebornStore = action - ACTION_REBORN_SCROLL_CLASS;
        if (action >= ACTION_REBORN_SCROLL_CLASS && rebornStore < REBORN_SCROLL_STORES.size() &&
            AscensionWarcraftReborn::IsRebornCharacter(player))
        {
            CloseGossipMenuFor(player);
            player->GetSession()->SendListInventory(creature->GetGUID(), REBORN_SCROLL_STORES[rebornStore].Vendor);
            return true;
        }
        CloseGossipMenuFor(player);
        return true;
    }
};

void AddWorldforgedGuardianScripts()
{
    new npc_worldforged_guardian();
}
