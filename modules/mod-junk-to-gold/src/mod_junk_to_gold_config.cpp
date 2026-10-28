#include "Config.h"
#include "Log.h"
#include <fmt/core.h>
#include <sstream>
#include <fstream>

bool junk_Enable = false;

class JunkToGoldConfig
{
public:
    JunkToGoldConfig()
    {
    }

    void SetEnabled()
    {
        junk_Enable = sConfigMgr->GetOption<bool>("JunkToGold.Enable", true);
    }
};

static JunkToGoldConfig junkToGoldConfig;

// 在模块加载时调用此函数初始化配置
void LoadJunkToGoldConfig()
{
    junkToGoldConfig.SetEnabled();
}

