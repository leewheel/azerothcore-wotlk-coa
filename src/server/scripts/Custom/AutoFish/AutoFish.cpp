/*
 * Copyright 2026 Leewheel
 *
 * AutoFish - 玩家自动钓鱼功能
 * By leewheel 2026年10月28日
 * 从 LWCorePlayerbotsBlizzardLike2026Revision 移植并简化：
 *   1. 按老大要求，自动钓鱼对所有玩家直接可用，不设任务门槛
 *      （原版的藏宝海湾任务线 950100~950109、灌顶装置 8100010、
 *        技能 12100006/12100007 一并裁掉——COA 客户端没有这些自定义法术/物品）
 *   2. 命令简化为「自动钓鱼」，SEC_PLAYER，聊天栏输入即开/关
 *
 * 功能:
 *   1. 检查玩家是否已学钓鱼、背包是否有鱼竿、是否在水边
 *   2. 自动装备鱼竿，自动使用最高等级鱼饵
 *   3. 自动施放钓鱼技能，自动拾取鱼漂中的鱼
 *   4. 背包满时丢弃钓起的鱼
 */

#include "ScriptMgr.h"
#include "Player.h"
#include "Chat.h"
#include "CommandScript.h"
#include "Item.h"
#include "ItemTemplate.h"
#include "SpellInfo.h"
#include "SpellMgr.h"
#include "SpellAuraDefines.h"
#include "Spell.h"
#include "SpellScript.h"
#include "GameObject.h"
#include "GameObjectData.h"
#include "Map.h"
#include "Log.h"
#include "DBCStores.h"
#include "DBCStructure.h"
#include "DBCEnums.h"
#include "SharedDefines.h"
#include "ObjectAccessor.h"
#include "WorldSession.h"
#include "LootMgr.h"
#include "Bag.h"
#include <vector>
#include <algorithm>
#include <unordered_map>
#include <cmath>

using namespace Acore::ChatCommands;

namespace
{

// ==================== 常量 ====================

// 钓鱼法术等级列表（从高到低）
// 7620=初级 7731=中级 7732=高级 18248=专家级 33095=大师级 51294=宗师级
static constexpr uint32 FISHING_SPELL_RANKS[] = { 51294, 33095, 18248, 7732, 7731, 7620 };
static constexpr uint32 FISHING_SKILL_ID = 356;

static constexpr uint32 TICK_MS = 500;
static constexpr uint32 CAST_TIMEOUT_MS = 3000;       // 施放后等待鱼漂出现的超时
static constexpr uint32 BOBBER_TIMEOUT_MS = 30000;    // 等待鱼漂就绪的超时
static constexpr uint32 RECAST_DELAY_MS = 1200;       // 重新施放的间隔
static constexpr uint32 LOOT_DELAY_MS = 300;          // 拾取前等待

// 查找玩家已学的最高级钓鱼法术
uint32 GetBestFishingSpell(Player* player)
{
    for (uint32 spellId : FISHING_SPELL_RANKS)
    {
        if (player->HasSpell(spellId))
            return spellId;
    }
    return 0;
}

// ==================== 状态机 ====================

enum AutoFishState : uint8
{
    AF_STATE_IDLE = 0,
    AF_STATE_CASTING,    // 已施放钓鱼，等待鱼漂出现
    AF_STATE_WAITING,    // 鱼漂已出现，等待就绪
    AF_STATE_LOOTING,    // 鱼漂就绪，正在拾取
    AF_STATE_RECAST      // 等待重新施放
};

struct AutoFishPlayerState
{
    bool active = false;
    uint8 state = AF_STATE_IDLE;
    uint32 stateSinceMs = 0;
    uint32 tickAccum = 0;
    bool hasCasted = false;        // 当前 CASTING 状态是否已施放过钓鱼技能
    bool lureAttempted = false;    // 当前 RECAST 周期内是否已尝试过施放鱼饵
    ObjectGuid bobberGuid;
};

static std::unordered_map<ObjectGuid, AutoFishPlayerState> g_autoFishStates;

// ==================== 辅助函数 ====================

// 检查玩家是否已学钓鱼
bool PlayerHasFishingSkill(Player* player)
{
    return player->GetSkillValue(FISHING_SKILL_ID) > 0;
}

// 检查主手是否已装备鱼竿
bool IsFishingPoleEquipped(Player* player)
{
    Item* mainHand = player->GetItemByPos(INVENTORY_SLOT_BAG_0, EQUIPMENT_SLOT_MAINHAND);
    if (!mainHand || mainHand->IsBroken())
        return false;
    ItemTemplate const* proto = mainHand->GetTemplate();
    return proto && proto->Class == ITEM_CLASS_WEAPON && proto->SubClass == ITEM_SUBCLASS_WEAPON_FISHING_POLE;
}

// 判断物品模板是否为鱼竿
bool IsFishingPole(ItemTemplate const* proto)
{
    return proto && proto->Class == ITEM_CLASS_WEAPON && proto->SubClass == ITEM_SUBCLASS_WEAPON_FISHING_POLE;
}

// 在背包中查找鱼竿（不含已装备的）
Item* FindFishingPoleInBags(Player* player)
{
    // 背包（backpack）
    for (uint8 slot = INVENTORY_SLOT_ITEM_START; slot < INVENTORY_SLOT_ITEM_END; ++slot)
    {
        Item* item = player->GetItemByPos(INVENTORY_SLOT_BAG_0, slot);
        if (item && !item->IsBroken() && IsFishingPole(item->GetTemplate()))
            return item;
    }
    // 装备的袋子
    for (uint8 bag = INVENTORY_SLOT_BAG_START; bag < INVENTORY_SLOT_BAG_END; ++bag)
    {
        Bag* pBag = player->GetBagByPos(bag);
        if (!pBag)
            continue;
        for (uint8 slot = 0; slot < pBag->GetBagSize(); ++slot)
        {
            Item* item = player->GetItemByPos(bag, slot);
            if (item && !item->IsBroken() && IsFishingPole(item->GetTemplate()))
                return item;
        }
    }
    return nullptr;
}

// 装备鱼竿到主手
void EquipFishingPole(Player* player, Item* pole)
{
    if (!pole)
        return;

    uint16 srcPos = (uint16(pole->GetBagSlot()) << 8) | pole->GetSlot();
    uint16 dstPos = (uint16(INVENTORY_SLOT_BAG_0) << 8) | EQUIPMENT_SLOT_MAINHAND;
    player->SwapItem(srcPos, dstPos);
}

// 检查玩家附近是否有水
bool IsNearWater(Player* player)
{
    Map* map = player->GetMap();
    if (!map)
        return false;

    float const px = player->GetPositionX();
    float const py = player->GetPositionY();
    float const pz = player->GetPositionZ();
    float const ori = player->GetOrientation();
    float const collisionHeight = player->GetCollisionHeight();
    uint32 const phaseMask = player->GetPhaseMask();

    // 检查玩家面前 3、6、9 码处的三点
    float const distances[] = { 3.0f, 6.0f, 9.0f };
    for (float dist : distances)
    {
        float x = px + dist * std::cos(ori);
        float y = py + dist * std::sin(ori);
        float ground = map->GetHeight(phaseMask, x, y, pz + 5.0f, true, 50.0f);
        if (ground == INVALID_HEIGHT)
            ground = pz;

        LiquidData liquidData = map->GetLiquidData(phaseMask, x, y, pz, collisionHeight, MAP_ALL_LIQUIDS);
        if (liquidData.Status != LIQUID_MAP_NO_WATER && liquidData.Level > ground + 0.5f)
            return true;
    }
    return false;
}

// ==================== 鱼饵识别与使用 ====================

// 从鱼饵物品获取钓鱼技能加成值（0 表示不是鱼饵）
int32 GetLureFishingBonus(ItemTemplate const* proto)
{
    if (!proto)
        return 0;

    // 鱼饵的 Spells[0] 是使用法术
    if (!proto->Spells[0].SpellId || proto->Spells[0].SpellTrigger != ITEM_SPELLTRIGGER_ON_USE)
        return 0;

    SpellInfo const* enchantSpell = sSpellMgr->GetSpellInfo(proto->Spells[0].SpellId);
    if (!enchantSpell)
        return 0;

    // 法术必须装备物品类为武器且子类包含鱼竿
    if (enchantSpell->EquippedItemClass != ITEM_CLASS_WEAPON)
        return 0;
    if (!(enchantSpell->EquippedItemSubClassMask & (1 << ITEM_SUBCLASS_WEAPON_FISHING_POLE)))
        return 0;

    int32 bestBonus = 0;

    for (SpellEffectInfo const& eff : enchantSpell->GetEffects())
    {
        if (eff.Effect != SPELL_EFFECT_ENCHANT_ITEM_TEMPORARY)
            continue;

        uint32 enchantId = uint32(eff.MiscValue);
        if (!enchantId)
            continue;

        SpellItemEnchantmentEntry const* enchant = sSpellItemEnchantmentStore.LookupEntry(enchantId);
        if (!enchant)
            continue;

        // 遍历附魔的 3 个效果槽
        for (uint8 s = 0; s < MAX_SPELL_ITEM_ENCHANTMENT_EFFECTS; ++s)
        {
            if (enchant->type[s] != ITEM_ENCHANTMENT_TYPE_EQUIP_SPELL)
                continue;

            uint32 buffSpellId = enchant->spellid[s];
            if (!buffSpellId)
                continue;

            SpellInfo const* buffSpell = sSpellMgr->GetSpellInfo(buffSpellId);
            if (!buffSpell)
                continue;

            // 查找增加钓鱼技能的光环
            for (SpellEffectInfo const& buffEff : buffSpell->GetEffects())
            {
                if (buffEff.ApplyAuraName == SPELL_AURA_MOD_SKILL && buffEff.MiscValue == int32(FISHING_SKILL_ID))
                {
                    int32 bonus = buffEff.CalcValue();
                    if (bonus > bestBonus)
                        bestBonus = bonus;
                }
            }
        }
    }

    return bestBonus;
}

// 在背包中查找最好的鱼饵（钓鱼技能加成最高的）
Item* FindBestLure(Player* player)
{
    Item* bestLure = nullptr;
    int32 bestBonus = 0;

    auto checkItem = [&](Item* item)
    {
        if (!item || item->IsBroken())
            return;
        ItemTemplate const* proto = item->GetTemplate();
        if (!proto)
            return;
        int32 bonus = GetLureFishingBonus(proto);
        if (bonus > bestBonus)
        {
            bestBonus = bonus;
            bestLure = item;
        }
    };

    // 背包
    for (uint8 slot = INVENTORY_SLOT_ITEM_START; slot < INVENTORY_SLOT_ITEM_END; ++slot)
        checkItem(player->GetItemByPos(INVENTORY_SLOT_BAG_0, slot));

    // 装备的袋子
    for (uint8 bag = INVENTORY_SLOT_BAG_START; bag < INVENTORY_SLOT_BAG_END; ++bag)
    {
        Bag* pBag = player->GetBagByPos(bag);
        if (!pBag)
            continue;
        for (uint8 slot = 0; slot < pBag->GetBagSize(); ++slot)
            checkItem(player->GetItemByPos(bag, slot));
    }

    return bestLure;
}

// 检查已装备的鱼竿是否已有临时附魔（鱼饵）
bool HasLureApplied(Player* player)
{
    Item* mainHand = player->GetItemByPos(INVENTORY_SLOT_BAG_0, EQUIPMENT_SLOT_MAINHAND);
    if (!mainHand)
        return false;
    return mainHand->GetEnchantmentId(TEMP_ENCHANTMENT_SLOT) != 0;
}

// 使用鱼饵到已装备的鱼竿上
void ApplyLure(Player* player, Item* lure)
{
    if (!lure)
        return;

    Item* mainHand = player->GetItemByPos(INVENTORY_SLOT_BAG_0, EQUIPMENT_SLOT_MAINHAND);
    if (!mainHand || !IsFishingPole(mainHand->GetTemplate()))
        return;

    InventoryResult result = player->CanUseItem(lure);
    if (result != EQUIP_ERR_OK)
        return;

    SpellCastTargets targets;
    targets.SetItemTarget(mainHand);
    player->CastItemUseSpell(lure, targets, 1, 0);
}

// ==================== 鱼漂检测与拾取 ====================

// 获取玩家的钓鱼鱼漂（通过引导对象）
GameObject* GetFishingBobber(Player* player)
{
    ObjectGuid channelGuid = player->GetGuidValue(UNIT_FIELD_CHANNEL_OBJECT);
    if (channelGuid.IsEmpty() || !channelGuid.IsGameObject())
        return nullptr;

    GameObject* go = player->GetMap()->GetGameObject(channelGuid);
    if (!go)
        return nullptr;

    // 确认是鱼漂且属于该玩家
    if (go->GetGoType() != GAMEOBJECT_TYPE_FISHINGNODE)
        return nullptr;
    if (go->GetOwnerGUID() != player->GetGUID())
        return nullptr;

    return go;
}

// 鱼漂是否就绪（可拾取）
bool IsBobberReady(GameObject* bobber)
{
    return bobber && bobber->getLootState() == GO_READY;
}

// 自动拾取鱼漂中的所有物品
// 调用 GameObject::Use 走完整的钓鱼判定流程（含技能增长），再自动拾取
void AutoLootBobber(Player* player, GameObject* bobber)
{
    if (!player || !bobber)
        return;

    // 调用 bobber->Use 触发完整的钓鱼流程（与玩家右键点击鱼漂一致）：
    //   1. 计算区域钓鱼技能要求与成功率
    //   2. UpdateFishingSkill() - 钓鱼技能增长
    //   3. SendLoot - 生成 loot 并打开拾取窗口（成功 LOOT_FISHING / 失败 LOOT_FISHING_JUNK）
    //   4. FinishSpell - 结束钓鱼引导
    bobber->Use(player);

    // Use 之后，SendLoot 已被调用，loot 数据已填充
    // 通过 player->GetLootGUID() 获取实际 loot 目标（可能是鱼漂或附近的钓鱼洞）
    ObjectGuid lootGuid = player->GetLootGUID();
    if (lootGuid.IsEmpty())
        return;  // 没有 loot（例如鱼跑了或钓鱼洞分支）

    Loot* loot = nullptr;
    if (lootGuid.IsGameObject())
    {
        if (GameObject* lootGo = player->GetMap()->GetGameObject(lootGuid))
            loot = &lootGo->loot;
    }

    if (!loot || loot->empty())
    {
        player->GetSession()->DoLootRelease(lootGuid);
        return;
    }

    // 遍历所有 loot 槽位，尝试存入背包
    uint32 maxSlot = loot->GetMaxSlotInLootFor(player);
    bool bagFull = false;
    for (uint32 slot = 0; slot < maxSlot; ++slot)
    {
        InventoryResult msg = EQUIP_ERR_OK;
        player->StoreLootItem(uint8(slot), loot, msg);
        if (msg == EQUIP_ERR_BAG_FULL || msg == EQUIP_ERR_INVENTORY_FULL)
        {
            bagFull = true;
            break;  // 背包满，丢弃剩余
        }
    }

    if (bagFull)
    {
        ChatHandler(player->GetSession()).PSendSysMessage("|cffffcc00[自动钓鱼]|r 背包已满，部分渔获已丢弃。");
    }

    // 关闭拾取窗口并移除鱼漂
    player->GetSession()->DoLootRelease(lootGuid);
}

// ==================== 状态机核心 ====================

void SetState(AutoFishPlayerState& st, AutoFishState newState)
{
    st.state = newState;
    st.stateSinceMs = getMSTime();
    st.hasCasted = false;
    // 进入 RECAST 状态时重置鱼饵尝试标志
    if (newState == AF_STATE_RECAST)
        st.lureAttempted = false;
}

void StartAutoFish(Player* player, ChatHandler* /*handler*/)
{
    ChatHandler chat(player->GetSession());

    // 条件检查 1: 已学钓鱼
    if (!PlayerHasFishingSkill(player))
    {
        chat.PSendSysMessage("|cffff0000[自动钓鱼]|r 你还没有学会钓鱼技能！");
        return;
    }

    // 条件检查 2: 背包有鱼竿或已装备鱼竿
    if (!IsFishingPoleEquipped(player) && !FindFishingPoleInBags(player))
    {
        chat.PSendSysMessage("|cffff0000[自动钓鱼]|r 背包中没有鱼竿！");
        return;
    }

    // 条件检查 3: 在水边
    if (!IsNearWater(player))
    {
        chat.PSendSysMessage("|cffff0000[自动钓鱼]|r 你不在水边，无法钓鱼！");
        return;
    }

    // 额外安全检查
    if (player->IsInCombat())
    {
        chat.PSendSysMessage("|cffff0000[自动钓鱼]|r 战斗中无法钓鱼！");
        return;
    }

    if (player->isDead())
    {
        chat.PSendSysMessage("|cffff0000[自动钓鱼]|r 死亡状态下无法钓鱼！");
        return;
    }

    // 装备鱼竿
    if (!IsFishingPoleEquipped(player))
    {
        Item* pole = FindFishingPoleInBags(player);
        if (pole)
        {
            EquipFishingPole(player, pole);
            chat.PSendSysMessage("|cff00ff00[自动钓鱼]|r 已自动装备鱼竿。");
        }
    }

    // 初始化状态
    AutoFishPlayerState& st = g_autoFishStates[player->GetGUID()];
    st = AutoFishPlayerState();
    st.active = true;
    SetState(st, AF_STATE_RECAST);  // 从 RECAST 开始，短延迟后施放

    chat.PSendSysMessage("|cff00ff00[自动钓鱼]|r 自动钓鱼已开启！再次输入命令可停止。");
}

void StopAutoFish(Player* player, ChatHandler* /*handler*/)
{
    ChatHandler chat(player->GetSession());

    auto itr = g_autoFishStates.find(player->GetGUID());
    if (itr == g_autoFishStates.end() || !itr->second.active)
    {
        chat.PSendSysMessage("|cffffcc00[自动钓鱼]|r 自动钓鱼未在运行。");
        return;
    }

    g_autoFishStates.erase(itr);
    chat.PSendSysMessage("|cffff0000[自动钓鱼]|r 自动钓鱼已停止。");
}

void UpdateAutoFish(Player* player, uint32 diff)
{
    AutoFishPlayerState* stPtr = nullptr;
    auto itr = g_autoFishStates.find(player->GetGUID());
    if (itr != g_autoFishStates.end() && itr->second.active)
        stPtr = &itr->second;

    if (!stPtr)
        return;

    AutoFishPlayerState& st = *stPtr;

    // 安全检查：死亡/不在世界 → 停止
    if (player->isDead() || !player->IsInWorld())
    {
        st.active = false;
        return;
    }

    // 战斗中暂停（不施放，等战斗结束）
    if (player->IsInCombat())
    {
        st.tickAccum = 0;
        return;
    }

    // 累积 tick
    st.tickAccum += diff;
    if (st.tickAccum < TICK_MS)
        return;
    st.tickAccum = 0;

    uint32 const now = getMSTime();

    switch (st.state)
    {
        case AF_STATE_RECAST:
        {
            if (getMSTimeDiff(st.stateSinceMs, now) < RECAST_DELAY_MS)
                return;

            // 修复鱼饵应用死循环 bug：
            // 每个 RECAST 周期只尝试一次鱼饵，且施放鱼饵前检查是否正在施法，
            // 避免鱼饵法术施放时间较长时被下一 tick 重复尝试打断。
            if (IsFishingPoleEquipped(player) && !HasLureApplied(player) && !st.lureAttempted)
            {
                st.lureAttempted = true;
                Item* lure = FindBestLure(player);
                if (lure && !player->IsNonMeleeSpellCast(false, false, true))
                {
                    ApplyLure(player, lure);
                    // 给鱼饵附魔一点时间生效
                    return;
                }
            }

            // 施放钓鱼技能（使用玩家已学的最高级钓鱼法术）
            if (player->IsNonMeleeSpellCast(false, false, true))
                return;  // 正在施放其他法术

            uint32 fishingSpell = GetBestFishingSpell(player);
            if (!fishingSpell)
            {
                ChatHandler(player->GetSession()).PSendSysMessage("|cffff0000[自动钓鱼]|r 未找到已学的钓鱼法术，停止自动钓鱼。");
                st.active = false;
                return;
            }

            player->CastSpell(player, fishingSpell, false);
            SetState(st, AF_STATE_CASTING);
            break;
        }

        case AF_STATE_CASTING:
        {
            // 查找鱼漂
            GameObject* bobber = GetFishingBobber(player);
            if (bobber)
            {
                st.bobberGuid = bobber->GetGUID();
                SetState(st, AF_STATE_WAITING);
                return;
            }

            // 超时未出现鱼漂 → 重新施放
            if (getMSTimeDiff(st.stateSinceMs, now) > CAST_TIMEOUT_MS)
            {
                // 可能施放失败（没水、面向不对等），重新尝试
                SetState(st, AF_STATE_RECAST);
            }
            break;
        }

        case AF_STATE_WAITING:
        {
            GameObject* bobber = player->GetMap()->GetGameObject(st.bobberGuid);
            if (!bobber)
            {
                // 鱼漂消失（可能被移动打断或引导结束）→ 重新施放
                SetState(st, AF_STATE_RECAST);
                return;
            }

            if (IsBobberReady(bobber))
            {
                SetState(st, AF_STATE_LOOTING);
                return;
            }

            // 超时 → 重新施放
            if (getMSTimeDiff(st.stateSinceMs, now) > BOBBER_TIMEOUT_MS)
            {
                SetState(st, AF_STATE_RECAST);
            }
            break;
        }

        case AF_STATE_LOOTING:
        {
            GameObject* bobber = player->GetMap()->GetGameObject(st.bobberGuid);
            if (!bobber)
            {
                SetState(st, AF_STATE_RECAST);
                return;
            }

            // 短暂延迟后拾取（等鱼漂动画稳定）
            if (getMSTimeDiff(st.stateSinceMs, now) < LOOT_DELAY_MS)
                return;

            AutoLootBobber(player, bobber);
            st.bobberGuid.Clear();
            SetState(st, AF_STATE_RECAST);
            break;
        }

        default:
            SetState(st, AF_STATE_RECAST);
            break;
    }
}

// ==================== 脚本注册 ====================

class AutoFishPlayerScript : public PlayerScript
{
public:
    AutoFishPlayerScript() : PlayerScript("AutoFishPlayerScript") { }

    void OnPlayerLogout(Player* player) override
    {
        g_autoFishStates.erase(player->GetGUID());
    }

    void OnPlayerUpdate(Player* player, uint32 diff) override
    {
        UpdateAutoFish(player, diff);
    }
};

class AutoFishCommandHandler : public CommandScript
{
public:
    AutoFishCommandHandler() : CommandScript("AutoFishCommandHandler") { }

    ChatCommandTable GetCommands() const override
    {
        // By leewheel 2026年10月28日 - 按老大要求：命令「自动钓鱼」，所有玩家可用（SEC_PLAYER），
        //   不设任何任务门槛——必要的钓鱼条件（会钓鱼/有鱼竿/在水边/非战斗非死亡）
        //   由 StartAutoFish 自己把关。
        static ChatCommandTable commands =
        {
            { "自动钓鱼", HandleAutoFishToggle, SEC_PLAYER, Console::No },
        };
        return commands;
    }

    static bool HandleAutoFishToggle(ChatHandler* handler)
    {
        Player* player = handler->GetPlayer();
        if (!player)
            return false;

        auto itr = g_autoFishStates.find(player->GetGUID());
        bool isActive = (itr != g_autoFishStates.end() && itr->second.active);

        if (isActive)
            StopAutoFish(player, handler);
        else
            StartAutoFish(player, handler);

        return true;
    }
};

} // namespace

void AddSC_AutoFish()
{
    new AutoFishPlayerScript();
    new AutoFishCommandHandler();
}
// By leewheel 2026年10月28日
