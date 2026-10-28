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

/// \addtogroup Acored
/// @{
/// \file

#include "CliRunnable.h"
#include "Config.h"
#include "ObjectMgr.h"
#include "World.h"
#include <fmt/core.h>

#if AC_PLATFORM == AC_PLATFORM_WINDOWS
#include <windows.h>
#include <iostream>
#else
#include "Chat.h"
#include "ChatCommand.h"
#include <cstring>
#include <readline/history.h>
#include <readline/readline.h>
#endif

static constexpr char CLI_PREFIX[] = "AC> ";

static inline void PrintCliPrefix()
{
    fmt::print(CLI_PREFIX);
}

#if AC_PLATFORM != AC_PLATFORM_WINDOWS
namespace Acore::Impl::Readline
{
    static std::vector<std::string> vec;
    char* cli_unpack_vector(char const*, int state)
    {
        static std::size_t i=0;
        if (!state)
            i = 0;
        if (i < vec.size())
            return strdup(vec[i++].c_str());
        else
            return nullptr;
    }

    char** cli_completion(char const* text, int /*start*/, int /*end*/)
    {
        ::rl_attempted_completion_over = 1;
        vec = Acore::ChatCommands::GetAutoCompletionsFor(CliHandler(nullptr,nullptr), text);
        return ::rl_completion_matches(text, &cli_unpack_vector);
    }

    int cli_hook_func()
    {
           if (World::IsStopped())
               ::rl_done = 1;
           return 0;
    }
}
#endif

#if AC_PLATFORM == AC_PLATFORM_WINDOWS
/// 把 UTF-8 文本转换为系统 ANSI 代码页（中文 Windows = 936/GBK）。
/// 控制台代码页已在 CliThread 中设为 GetACP()，CLI 命令回显若直出 UTF-8 字节，
/// 会在 GBK 控制台里显示为乱码；统一转成 GBK 写出后中文即可正常显示。
/// 转换失败时原样返回 UTF-8，保证输出永不丢内容。实现与 AppenderFile.cpp 保持一致。
/// By leewheel 2026年10月28日
static std::string Utf8ToSystemAnsi(std::string const& utf8)
{
    if (utf8.empty())
        return utf8;

    int wlen = MultiByteToWideChar(CP_UTF8, 0, utf8.c_str(), int(utf8.size()), nullptr, 0);
    if (wlen <= 0)
        return utf8;

    std::wstring wide(wlen, 0);
    MultiByteToWideChar(CP_UTF8, 0, utf8.c_str(), int(utf8.size()), &wide[0], wlen);

    int alen = WideCharToMultiByte(CP_ACP, 0, wide.c_str(), wlen, nullptr, 0, nullptr, nullptr);
    if (alen <= 0)
        return utf8;

    std::string ansi(alen, 0);
    WideCharToMultiByte(CP_ACP, 0, wide.c_str(), wlen, &ansi[0], alen, nullptr, nullptr);
    return ansi;
}
#endif

void utf8print(void* /*arg*/, std::string_view str)
{
#if AC_PLATFORM == AC_PLATFORM_WINDOWS
    // CLI 回显按系统 ANSI（GBK）写出，与控制台代码页一致，中文正常显示。By leewheel 2026年10月28日
    std::string ansiLine = Utf8ToSystemAnsi(std::string(str));
    fmt::print("{}", ansiLine);
#else
{
    fmt::print("{}", str);
    fflush(stdout);
}
#endif
}

void commandFinished(void*, bool /*success*/)
{
    PrintCliPrefix();
    fflush(stdout);
}

#ifdef linux
// Non-blocking keypress detector, when return pressed, return 1, else always return 0
int kb_hit_return()
{
    struct timeval tv;
    fd_set fds;
    tv.tv_sec = 0;
    tv.tv_usec = 0;
    FD_ZERO(&fds);
    FD_SET(STDIN_FILENO, &fds);
    select(STDIN_FILENO+1, &fds, nullptr, nullptr, &tv);
    return FD_ISSET(STDIN_FILENO, &fds);
}
#endif

/// %Thread start
void CliThread()
{
#if AC_PLATFORM == AC_PLATFORM_WINDOWS
    // 控制台代码页保持系统 ANSI（中文 Windows = 936/GBK），与日志写出编码保持一致。
    // 原先强制 SetConsoleOutputCP(CP_UTF8) 会让 AppenderConsole 经 CharToOemBuffW
    // 转出的 GBK 字节在控制台里被按 UTF-8 解读，中文全部显示为乱码。
    // By leewheel 2026年10月28日
    SetConsoleCP(GetACP());
    SetConsoleOutputCP(GetACP());

    // print this here the first time
    // later it will be printed after command queue updates
    PrintCliPrefix();
#else
    ::rl_attempted_completion_function = &Acore::Impl::Readline::cli_completion;
    {
        static char BLANK = '\0';
        ::rl_completer_word_break_characters = &BLANK;
    }
    ::rl_event_hook = &Acore::Impl::Readline::cli_hook_func;
#endif

    if (sConfigMgr->GetOption<bool>("BeepAtStart", true))
        printf("\a"); // \a = Alert

#if AC_PLATFORM == AC_PLATFORM_WINDOWS
    if (sConfigMgr->GetOption<bool>("FlashAtStart", true))
    {
        FLASHWINFO fInfo;
        fInfo.cbSize = sizeof(FLASHWINFO);
        fInfo.dwFlags = FLASHW_TRAY | FLASHW_TIMERNOFG;
        fInfo.hwnd = GetConsoleWindow();
        fInfo.uCount = 0;
        fInfo.dwTimeout = 0;
        FlashWindowEx(&fInfo);
    }

    // Get console input handle once for reading commands
    HANDLE hStdIn = GetStdHandle(STD_INPUT_HANDLE);
    if (hStdIn == INVALID_HANDLE_VALUE)
    {
        LOG_ERROR("server.worldserver", "Failed to get console input handle");
        return;
    }
#endif

    ///- As long as the World is running (no World::m_stopEvent), get the command line and handle it
    while (!World::IsStopped())
    {
        fflush(stdout);

        std::string command;

#if AC_PLATFORM == AC_PLATFORM_WINDOWS

        static bool checkedConsole = false;
        static bool isRealConsole = false;

        if (!checkedConsole)
        {
            DWORD mode = 0;
            isRealConsole = GetConsoleMode(hStdIn, &mode);
            checkedConsole = true;
        }

        if (isRealConsole)
        {
            // ===== Real Windows Console =====
            wchar_t commandbuf[256];
            DWORD charsRead = 0;

            if (ReadConsoleW(hStdIn, commandbuf,
                sizeof(commandbuf) / sizeof(wchar_t) - 1,
                &charsRead, nullptr))
            {
                if (charsRead > 0)
                {
                    commandbuf[charsRead] = L'\0';
                    if (!WStrToUtf8(commandbuf, charsRead, command))
                    {
                        PrintCliPrefix();
                        continue;
                    }
                }
            }
        }
        else
        {
            // ===== Redirected input (pipe) =====
            if (!std::getline(std::cin, command))
            {
                World::StopNow(SHUTDOWN_EXIT_CODE);
                break;
            }
        }

#else
        char* command_str = readline(CLI_PREFIX);
        ::rl_bind_key('\t', ::rl_complete);
        if (command_str != nullptr)
        {
            command = command_str;
            free(command_str);
        }
#endif

        if (!command.empty())
        {
            std::size_t nextLineIndex = command.find_first_of("\r\n");
            if (nextLineIndex != std::string::npos)
            {
                if (nextLineIndex == 0)
                {
#if AC_PLATFORM == AC_PLATFORM_WINDOWS
                    PrintCliPrefix();
#endif
                    continue;
                }

                command.erase(nextLineIndex);
            }

            fflush(stdout);
            sWorld->QueueCliCommand(new CliCommandHolder(nullptr, command.c_str(), &utf8print, &commandFinished));
#if AC_PLATFORM != AC_PLATFORM_WINDOWS
            add_history(command.c_str());
#endif
        }
        else if (feof(stdin))
        {
            World::StopNow(SHUTDOWN_EXIT_CODE);
        }
    }
}
