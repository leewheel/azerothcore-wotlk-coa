/* Copyright (C) 2016+ AzerothCore, GNU AGPL v3. */

// By leewheel 20261116 神秘附魔国度专属物品过滤：game 层前向声明钩子。
// 背景：拍卖行搜索器（AuctionHouseSearcher.cpp）与商人列表（ItemHandler.cpp）位于 game.lib，
// 需要按当前国度过滤神秘附魔专属物品；但项目依赖为 game <- coa 单向，game 层不能 include
// coa 层头文件、也不能反向链接 coa.lib。故在 game 层仅声明函数原型，真实实现放在 coa 层
// AscensionMysticEnchant.cpp，由 worldserver 最终链接期统一解析符号（同时链接 game.lib 与 coa.lib）。
#ifndef ASCENSION_REALM_ITEM_FILTER_H
#define ASCENSION_REALM_ITEM_FILTER_H

#include "Define.h"

namespace AscensionMysticEnchant
{
// 判定物品是否对当前国度隐藏：未开放神秘附魔的基础服隐藏专精令牌与神秘卷轴。
// 实现：src/server/coa/AscensionMysticEnchant.cpp
bool IsItemHiddenForRealm(uint32 itemId);
}

#endif
// End By leewheel 20261116
