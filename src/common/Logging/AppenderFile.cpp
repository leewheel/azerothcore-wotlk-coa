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

#include "AppenderFile.h"
#include "Log.h"
#include "LogMessage.h"
#include "StringConvert.h"
#include "Timer.h"
#include <algorithm>

#if AC_PLATFORM == AC_PLATFORM_WINDOWS
#include <Windows.h>

/// 把 UTF-8 文本转换为系统 ANSI 代码页（中文 Windows = 936/GBK），
/// 让 Logs/Server.log 等日志文件在记事本等默认 ANSI 查看器里直接显示中文而非乱码。
/// 转换失败时原样返回 UTF-8，保证日志永不丢内容。
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

AppenderFile::AppenderFile(uint8 id, std::string const& name, LogLevel level, AppenderFlags flags, std::vector<std::string_view> const& args) :
    Appender(id, name, level, flags),
    logfile(nullptr),
    _logDir(sLog->GetLogsDir()),
    _maxFileSize(0),
    _fileSize(0)
{
    if (args.size() < 4)
    {
        throw InvalidAppenderArgsException(Acore::StringFormat("Log::CreateAppenderFromConfig: Missing file name for appender {}", name));
    }

    _fileName.assign(args[3]);

    std::string mode = "a";
    if (4 < args.size())
    {
        mode.assign(args[4]);
    }

    if (flags & APPENDER_FLAGS_USE_TIMESTAMP)
    {
        std::size_t dot_pos = _fileName.find_last_of('.');
        if (dot_pos != std::string::npos)
        {
            _fileName.insert(dot_pos, sLog->GetLogsTimestamp());
        }
        else
        {
            _fileName += sLog->GetLogsTimestamp();
        }
    }

    if (5 < args.size())
    {
        if (Optional<uint32> size = Acore::StringTo<uint32>(args[5]))
        {
            _maxFileSize = *size;
        }
        else
        {
            throw InvalidAppenderArgsException(Acore::StringFormat("Log::CreateAppenderFromConfig: Invalid size '{}' for appender {}", args[5], name));
        }
    }

    _dynamicName = std::string::npos != _fileName.find("%s");
    _backup = (flags & APPENDER_FLAGS_MAKE_FILE_BACKUP) != 0;

    if (!_dynamicName)
    {
        logfile = OpenFile(_fileName, mode, (mode == "w") && _backup);
    }
}

AppenderFile::~AppenderFile()
{
    CloseFile();
}

void AppenderFile::_write(LogMessage const* message)
{
    bool exceedMaxSize = _maxFileSize > 0 && (_fileSize.load() + message->Size()) > _maxFileSize;

    if (_dynamicName)
    {
        char namebuf[ACORE_PATH_MAX];
        snprintf(namebuf, ACORE_PATH_MAX, _fileName.c_str(), message->param1.c_str());

        // always use "a" with dynamic name otherwise it could delete the log we wrote in last _write() call
        FILE* file = OpenFile(namebuf, "a", _backup || exceedMaxSize);
        if (!file)
        {
            return;
        }

#if AC_PLATFORM == AC_PLATFORM_WINDOWS
        // 日志按系统 ANSI（GBK）写出，Windows 记事本默认编码即可直接读中文。By leewheel 2026年10月28日
        std::string ansiLine = Utf8ToSystemAnsi(message->prefix) + Utf8ToSystemAnsi(message->text);
        fprintf(file, "%s\n", ansiLine.c_str());
#else
        fprintf(file, "%s%s\n", message->prefix.c_str(), message->text.c_str());
#endif
        fflush(file);
        _fileSize += uint64(message->Size());
        fclose(file);

        return;
    }
    else if (exceedMaxSize)
    {
        logfile = OpenFile(_fileName, "w", true);
    }

    if (!logfile)
    {
        return;
    }

#if AC_PLATFORM == AC_PLATFORM_WINDOWS
    // 日志按系统 ANSI（GBK）写出，Windows 记事本默认编码即可直接读中文。By leewheel 2026年10月28日
    std::string ansiLine = Utf8ToSystemAnsi(message->prefix) + Utf8ToSystemAnsi(message->text);
    fprintf(logfile, "%s\n", ansiLine.c_str());
#else
    fprintf(logfile, "%s%s\n", message->prefix.c_str(), message->text.c_str());
#endif

    auto const now = std::chrono::steady_clock::now();
    if (message->level <= LOG_LEVEL_WARN || now - _lastFlush >= std::chrono::milliseconds(250))
    {
        fflush(logfile);
        _lastFlush = now;
    }
    _fileSize += uint64(message->Size());
}

FILE* AppenderFile::OpenFile(std::string const& filename, std::string const& mode, bool backup)
{
    std::string fullName(_logDir + filename);
    if (backup)
    {
        CloseFile();
        std::string newName(fullName);
        newName.push_back('.');
        newName.append(LogMessage::getTimeStr(GetEpochTime()));
        std::replace(newName.begin(), newName.end(), ':', '-');
        rename(fullName.c_str(), newName.c_str()); // no error handling... if we couldn't make a backup, just ignore
    }

    if (FILE* ret = fopen(fullName.c_str(), mode.c_str()))
    {
        _fileSize = ftell(ret);
        return ret;
    }

    return nullptr;
}

void AppenderFile::CloseFile()
{
    if (logfile)
    {
        fclose(logfile);
        logfile = nullptr;
    }
}
