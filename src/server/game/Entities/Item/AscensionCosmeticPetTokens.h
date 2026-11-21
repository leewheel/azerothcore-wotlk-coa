/* Copyright (C) 2016+ AzerothCore, GNU AGPL v3. */
#ifndef ASCENSION_COSMETIC_PET_TOKENS_H
#define ASCENSION_COSMETIC_PET_TOKENS_H

#include "Define.h"

class Player;

namespace AscensionCosmeticPetTokens
{
bool AvailableOnRealm(uint32 itemId);

// By leewheel 20261121 宠物令牌（驯兽大师的哨子/哨角等）的使用入口：
// 返回 true 表示该物品是宠物令牌且已处理（驯服成功或已给出中文失败原因），调用方不应再施放物品法术。
bool UseTokenItem(Player* player, uint32 itemId);
// End By leewheel
}

#endif
