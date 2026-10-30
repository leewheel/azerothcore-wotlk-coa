/*
 * This file is part of the Conquest of Azeroth core. See AUTHORS file for Copyright information;
 * released under GNU AGPL v3 license, you may redistribute it and/or modify it under version 3
 * of the License, or (at your option) any later version.
 */

// COA 自定义职业（12..32，如 Tinker 28）没有标准职业枚举，ascension_custom_class 表里为每个自定义
// 职业记录了它的原型职业（fallback_class）。C++ 侧以前从没读过这张表：Player::IsClass() 只做硬比较，
// 于是 Tinker（原型是猎人）这类职业召唤的宠物归类不到 HUNTER_PET，Guardian::InitStatsForLevel
// 每只宠物都会刷一条 "Unknown type pet ... class 28" 的 LOG_ERROR。
// 这里把表读进来，借 PlayerScript::OnPlayerBeforeGuardianInitStatsForLevel 钩子按原型职业给宠物
// 定类型（原型是猎人 → 猎人宠，其余 → SUMMON_PET），从根上消除那条 ERROR，而不是把它静音。
//By leewheel 2026年10月31日

#ifndef ASCENSION_CUSTOM_CLASS_FALLBACK_H
#define ASCENSION_CUSTOM_CLASS_FALLBACK_H

#include "Define.h"

#include <cstdint>

namespace AscensionCustomClassFallback
{
    void Load();

    // 返回该职业的原型职业；标准职业（或表里没记录）返回自身。
    uint8 GetFallbackClass(uint8 classId);
}

void AddSC_AscensionCustomClassFallback();

#endif
