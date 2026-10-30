/*
 * This file is part of the Conquest of Azeroth core. See AUTHORS file for Copyright information;
 * released under GNU AGPL v3 license, you may redistribute it and/or modify it under version 3
 * of the License, or (at your option) any later version.
 */

// COA 自定义职业的原型职业（fallback_class）映射：从 ascension_custom_class 表读入，
// 并通过 PlayerScript::OnPlayerIsClass 让带 ClassContext 的职业判定回退到原型职业。
// 裸 IsClass(X)（不带上下文）保持严格比较，不动既有判定，避免牵连其它逻辑。
//By leewheel 2026年10月31日

#include "AscensionCustomClassFallback.h"

#include "DatabaseEnv.h"
#include "Log.h"
#include "Pet.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "SharedDefines.h"
#include "UnitDefines.h"

#include <array>

namespace
{
std::array<uint8, MAX_CLASSES> FallbackClasses{};
}

namespace AscensionCustomClassFallback
{
void Load()
{
    FallbackClasses.fill(0);

    QueryResult result = WorldDatabase.Query("SELECT `class`, `fallback_class` FROM `ascension_custom_class`");
    if (!result)
    {
        LOG_ERROR("coa", ">> ascension_custom_class 表读不到内容，COA 自定义职业无法回退到原型职业。");
        return;
    }

    uint32 loaded = 0;
    do
    {
        Field* fields = result->Fetch();
        uint8 classId = fields[0].Get<uint8>();
        uint8 fallback = fields[1].Get<uint8>();

        if (classId < MAX_CLASSES)
        {
            FallbackClasses[classId] = fallback;
            ++loaded;
        }
    } while (result->NextRow());

    LOG_INFO("server.loading", ">> 已加载 {} 个 COA 自定义职业的原型职业映射。", loaded);
}

uint8 GetFallbackClass(uint8 classId)
{
    if (classId >= MAX_CLASSES || FallbackClasses[classId] == 0)
        return classId;

    return FallbackClasses[classId];
}
}

class AscensionCustomClassFallbackWorldScript : public WorldScript
{
public:
    AscensionCustomClassFallbackWorldScript()
        : WorldScript("AscensionCustomClassFallbackWorldScript",
              { WORLDHOOK_ON_STARTUP, WORLDHOOK_ON_AFTER_CONFIG_LOAD })
    {
    }

    void OnStartup() override { AscensionCustomClassFallback::Load(); }

    // .reload config 之后重读一遍，方便改表后不重启就能生效 //By leewheel 2026年10月31日
    void OnAfterConfigLoad(bool /*reload*/) override { AscensionCustomClassFallback::Load(); }
};

class AscensionCustomClassFallbackPlayerScript : public PlayerScript
{
public:
    AscensionCustomClassFallbackPlayerScript()
        : PlayerScript("AscensionCustomClassFallbackPlayerScript",
              { PLAYERHOOK_ON_BEFORE_GUARDIAN_INIT_STATS_FOR_LEVEL })
    {
    }

    // Guardian::InitStatsForLevel 用主人的职业去猜宠物类型，只认标准职业那几个分支，
    // COA 自定义职业（12..32）的宠物因此归类不到，每只都刷一条 "Unknown type pet" 的 ERROR。
    // 这里按原型职业兜底：原型是猎人的按猎人宠处理，其余按 SUMMON_PET —— 与 Stormbringer
    // 风元素（原型萨满）在 AscensionStormbringerPet 里的既有处理一致。
    // 已经自己实现过这个钩子的职业（Stormbringer、Xoroth 等）判定结果相同，不受影响。
    //By leewheel 2026年10月31日
    void OnPlayerBeforeGuardianInitStatsForLevel(Player* player, Guardian* guardian, CreatureTemplate const*,
                                                 PetType& type) override
    {
        if (!guardian || !guardian->IsPet())
            return;  // 只管永久宠物，临时守护者不归这里

        uint8 const fallback = AscensionCustomClassFallback::GetFallbackClass(player->getClass());
        if (fallback == player->getClass())
            return;  // 标准职业：走 core 原本的分支

        type = (fallback == CLASS_HUNTER) ? HUNTER_PET : SUMMON_PET;
    }
};

void AddSC_AscensionCustomClassFallback()
{
    new AscensionCustomClassFallbackWorldScript();
    new AscensionCustomClassFallbackPlayerScript();
}
