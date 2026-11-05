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

#include "GameTime.h"
#include "Config.h"
#include "Timer.h"
#include <algorithm>
#include <atomic>
#include <limits>

namespace GameTime
{
    using namespace std::chrono;

    Seconds const StartTime = GetEpochTime();
    TimePoint const StartSteadyPoint = steady_clock::now();

    Seconds GameTime = GetEpochTime();
    Milliseconds GameMSTime = 0ms;

    SystemTimePoint GameTimeSystemPoint = SystemTimePoint::min();
    TimePoint GameTimeSteadyPoint = StartSteadyPoint;

    namespace
    {
        enum class SimulationState : uint8
        {
            Off,
            Armed,
            Running
        };

        constexpr Milliseconds MinimumSimulatedStep = 1ms;
        constexpr Milliseconds MaximumSimulatedStep = 2000ms;
        constexpr Milliseconds::rep NoPendingStep = std::numeric_limits<Milliseconds::rep>::max();
        constexpr SystemTimePoint::rep NoSystemAnchor = std::numeric_limits<SystemTimePoint::rep>::min();

        std::atomic<SimulationState> Simulation{SimulationState::Off};
        std::atomic<TimePoint::rep> SimulatedSteadyTicks{0};
        std::atomic<Milliseconds::rep> PendingStep{NoPendingStep};
        std::atomic<Milliseconds::rep> PendingJump{0};
        std::atomic<SystemTimePoint::rep> RequestedSystemAnchor{NoSystemAnchor};
        TimePoint SteadyAnchor;
        SystemTimePoint SystemAnchor;

        TimePoint SimulatedSteadyPoint()
        {
            return TimePoint(TimePoint::duration(SimulatedSteadyTicks.load(std::memory_order_relaxed)));
        }

        void ResetSimulationRequests()
        {
            PendingStep.store(NoPendingStep, std::memory_order_relaxed);
            PendingJump.store(0, std::memory_order_relaxed);
            RequestedSystemAnchor.store(NoSystemAnchor, std::memory_order_relaxed);
        }

        SystemTimePoint SimulatedSystemAnchor()
        {
            SystemTimePoint const now = system_clock::now();
            SystemTimePoint::rep const requested = RequestedSystemAnchor.exchange(NoSystemAnchor,
                std::memory_order_relaxed);
            if (requested == NoSystemAnchor)
                return now;

            return std::max(now, SystemTimePoint(SystemTimePoint::duration(requested)));
        }

        void AnchorSimulation()
        {
            TimePoint const applicationStart = GetApplicationStartTime();
            TimePoint const now = steady_clock::now();
            SteadyAnchor = now;
            SystemAnchor = SimulatedSystemAnchor();
            SimulatedSteadyTicks.store(now.time_since_epoch().count(), std::memory_order_relaxed);
            Acore::Time::SimulatedMSTime.store(duration_cast<Milliseconds>(now - applicationStart).count(),
                std::memory_order_relaxed);
            Simulation.store(SimulationState::Running, std::memory_order_release);
        }
    }

    Seconds GetStartTime()
    {
        return StartTime;
    }

    Seconds GetGameTime()
    {
        return GameTime;
    }

    //By leewheel 2026年11月5日 游戏内时间设置：把服务器真实时间换算成要发给客户端的世界时间。
    // 配置（configs/modules/coa.conf）：CoA.Clock.Mode 0/1/2，CoA.Clock.Hour，CoA.Clock.Minute，CoA.Clock.OffsetHours。
    // 只在首次调用时读配置，改配置需要重启 worldserver（和老大要求的“每次重启按配置开始”一致）。
    namespace
    {
        struct ShownClockSettings
        {
            int mode = 0;
            int hour = 8;
            int minute = 0;
            float offsetHours = 0.0f;
            bool loaded = false;
        };

        ShownClockSettings& ShownClock()
        {
            static ShownClockSettings settings;
            if (!settings.loaded)
            {
                settings.mode = sConfigMgr->GetOption<int>("CoA.Clock.Mode", 0);
                settings.hour = std::clamp(sConfigMgr->GetOption<int>("CoA.Clock.Hour", 8), 0, 23);
                settings.minute = std::clamp(sConfigMgr->GetOption<int>("CoA.Clock.Minute", 0), 0, 59);
                settings.offsetHours = std::clamp(sConfigMgr->GetOption<float>("CoA.Clock.OffsetHours", 0.0f), -24.0f, 24.0f);
                if (settings.mode < 0 || settings.mode > 2)
                    settings.mode = 0;
                settings.loaded = true;
            }
            return settings;
        }

        time_t SameDayAt(time_t when, int hour, int minute)
        {
            std::tm local{};
#ifdef _WIN32
            localtime_s(&local, &when);
#else
            localtime_r(&when, &local);
#endif
            local.tm_hour = hour;
            local.tm_min = minute;
            local.tm_sec = 0;
            local.tm_isdst = -1;
            return std::mktime(&local);
        }
    }

    time_t GetShownGameTime()
    {
        time_t const now = static_cast<time_t>(GetGameTime().count());
        ShownClockSettings const& settings = ShownClock();
        switch (settings.mode)
        {
            case 1:
                return SameDayAt(now, settings.hour, settings.minute);
            case 2:
                return now + static_cast<time_t>(std::llround(settings.offsetHours * 3600.0f));
            default:
                return now;
        }
    }
    //End By leewheel

    Milliseconds GetGameTimeMS()
    {
        return GameMSTime;
    }

    SystemTimePoint GetSystemTime()
    {
        return GameTimeSystemPoint;
    }

    TimePoint Now()
    {
        return GameTimeSteadyPoint;
    }

    Seconds GetUptime()
    {
        return duration_cast<Seconds>(GameTimeSteadyPoint - StartSteadyPoint);
    }

    void UpdateGameTimers()
    {
        if (Simulation.load(std::memory_order_relaxed) == SimulationState::Running)
        {
            TimePoint const simulatedSteadyPoint = SimulatedSteadyPoint();
            GameMSTime = duration_cast<Milliseconds>(simulatedSteadyPoint - GetApplicationStartTime());
            GameTimeSteadyPoint = simulatedSteadyPoint;
            GameTimeSystemPoint = SystemAnchor
                + duration_cast<SystemTimePoint::duration>(simulatedSteadyPoint - SteadyAnchor);
            GameTime = duration_cast<Seconds>(GameTimeSystemPoint.time_since_epoch());
            Acore::Time::SimulatedMSTime.store(GameMSTime.count(), std::memory_order_relaxed);
            return;
        }

        GameTime = GetEpochTime();
        GameMSTime = GetTimeMS();
        GameTimeSystemPoint = system_clock::now();
        GameTimeSteadyPoint = steady_clock::now();
    }

    void EnableSimulation()
    {
        SimulationState expected = SimulationState::Off;
        if (Simulation.compare_exchange_strong(expected, SimulationState::Armed))
            ResetSimulationRequests();
    }

    void DisableSimulation()
    {
        Simulation.store(SimulationState::Off, std::memory_order_release);
        Acore::Time::SimulatedMSTime.store(-1, std::memory_order_relaxed);
        UpdateGameTimers();
    }

    bool IsSimulated()
    {
        return Simulation.load(std::memory_order_relaxed) != SimulationState::Off;
    }

    void RequestStep(Milliseconds step)
    {
        Milliseconds::rep const requested = step.count();
        Milliseconds::rep pending = PendingStep.load(std::memory_order_relaxed);
        while (requested < pending)
            if (PendingStep.compare_exchange_weak(pending, requested, std::memory_order_relaxed))
                return;
    }

    Milliseconds TakeStep(Milliseconds realElapsed, Milliseconds minimumPaced)
    {
        SimulationState const state = Simulation.load(std::memory_order_relaxed);
        if (state == SimulationState::Off)
            return realElapsed < minimumPaced ? 0ms : realElapsed;

        if (state == SimulationState::Armed)
            AnchorSimulation();

        Milliseconds::rep const pending = PendingStep.exchange(NoPendingStep, std::memory_order_relaxed);
        Milliseconds step = realElapsed;
        if (pending != NoPendingStep)
            step = std::clamp(Milliseconds(pending), MinimumSimulatedStep, MaximumSimulatedStep);
        else if (realElapsed < minimumPaced)
            return 0ms;

        Milliseconds const jump(PendingJump.exchange(0, std::memory_order_relaxed));
        SimulatedSteadyTicks.fetch_add(duration_cast<TimePoint::duration>(step + jump).count(),
            std::memory_order_relaxed);
        return step;
    }

    void SetSimulatedSystemAnchor(SystemTimePoint anchor)
    {
        RequestedSystemAnchor.store(anchor.time_since_epoch().count(), std::memory_order_relaxed);
    }

    void AdvanceSimulation(Milliseconds jump)
    {
        if (jump > 0ms)
            PendingJump.fetch_add(jump.count(), std::memory_order_relaxed);
    }

    TimePoint SteadyNow()
    {
        if (Simulation.load(std::memory_order_acquire) == SimulationState::Running)
            return SimulatedSteadyPoint();

        return steady_clock::now();
    }

    Seconds GetCalendarTime()
    {
        return IsSimulated() ? GetGameTime() : GetEpochTime();
    }
}
