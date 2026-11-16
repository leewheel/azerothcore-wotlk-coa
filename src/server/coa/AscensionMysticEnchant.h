/* Copyright (C) 2016+ AzerothCore, GNU AGPL v3. */

#ifndef ASCENSION_MYSTIC_ENCHANT_H
#define ASCENSION_MYSTIC_ENCHANT_H

#include "AscensionMysticEnchantRules.h"
#include <array>
#include <optional>
#include <vector>

class Player;

namespace AscensionMysticEnchant
{
struct Collection
{
    std::array<uint32, QUALITY_MAX> Known{};
    std::array<uint32, QUALITY_MAX> Active{};
    std::array<bool, QUALITY_MAX> Offered{};
    uint32 KnownTotal = 0;
    uint32 KnownWorldforged = 0;
    uint32 OpenSlots = 0;
    uint32 FilledSlots = 0;
};

bool ApplyGuide(Player* player, std::vector<GuideEnchant> const& guide, bool learnMissing = false);

// By leewheel 20261116 神秘附魔国度专属物品判定：未开放神秘附魔的国度（基础服）应隐藏专精解锁令牌与神秘附魔卷轴，
// 玩家反馈这些物品在基础服拍卖行/遗失商店可见却无法使用，属跨国度内容泄漏，此判定供拍卖行搜索器与商人列表过滤使用
[[nodiscard]] bool IsItemHiddenForRealm(uint32 itemId);
// End By leewheel

uint32 ClearActivePreset(Player* player);

std::optional<Collection> Summarize(Player const* player);
}

#endif
