/*
 * Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU AGPL v3 license:
 * https://github.com/azerothcore/azerothcore-wotlk/blob/master/LICENSE-AGPL3
 */

//By leewheel 2026年11月9日
// 本文件原样引入上游核心配套提交 7fc67d942「CoA companion loot: read-only API for the looting companion」。
// 机器人模块 mod-playerbots 2.9.5 的「拾取宠物」（AiPlayerbot.AltLootCompanion，CoaLootPetAction.cpp）
// 直接 include 这个头文件；只合模块不合核心配套，就会在 CoaLootPetAction.cpp 报 C1083 找不到头文件。
// 语义与核心 ProcessCompanionLoot 完全一致：战利品变形器外观启用后任何伙伴都替玩家捡尸体，
// 平时只有 Lootbot 3000 与窃魔恶鬼自己捡、而且副本外才捡；剥皮刀外观启用后伙伴才剥皮。
// 核心侧实现在 AscensionCompat.cpp，那里的 CompanionLoot 枚举与本文件的常量用 static_assert 对齐。
//End By leewheel

#ifndef ASCENSION_COMPANION_LOOT_H
#define ASCENSION_COMPANION_LOOT_H

#include <cstdint>

class Player;

namespace Ascension::CompanionLooting
{
constexpr std::uint32_t LootAppearanceCategory = 38;
constexpr std::uint32_t SkinningAppearanceCategory = 61;
constexpr std::uint32_t LootTransfiguratorAppearance = 47520;
constexpr std::uint32_t SkinPeelerAppearance = 639807;
constexpr std::uint32_t LootTransfiguratorSpell = 84419;
constexpr std::uint32_t SkinPeelerSpell = 92864;
constexpr std::uint32_t Lootbot3000Creature = 44022;
constexpr std::uint32_t KleptomanicDemonCreature = 79026;

constexpr bool IsSelfLootingCompanion(std::uint32_t creatureEntry)
{
    return creatureEntry == Lootbot3000Creature || creatureEntry == KleptomanicDemonCreature;
}

constexpr bool LootsWith(bool appearanceActive, bool selfLootingCompanionOut, bool inRaid)
{
    return appearanceActive || (selfLootingCompanionOut && !inRaid);
}

constexpr bool SkinsWith(bool appearanceActive)
{
    return appearanceActive;
}

[[nodiscard]] bool HasLootAppearance(Player const* player);
[[nodiscard]] bool HasSkinningAppearance(Player const* player);
[[nodiscard]] bool CompanionLoots(Player const* player);
[[nodiscard]] bool CompanionSkins(Player const* player);
[[nodiscard]] float LootRadius(Player const* player);
[[nodiscard]] float SkinningRadius(Player const* player);
}

#endif
