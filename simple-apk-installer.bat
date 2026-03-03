@echo off
setlocal

:: Get script directory
set "SCRIPT_DIR=%~dp0"
set "APK_PATH=%~1"

if "%APK_PATH%"=="" (
    echo [!] ERROR: No APK file path provided.
    echo Usage: simple-apk-installer.bat ^<apk_path^>
    pause
    exit /b 1
)

:: Ensure powershell exists
where powershell.exe >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] ERROR: PowerShell.exe not found in PATH.
    pause
    exit /b 1
)

:: Run the powershell script
powershell.exe -ExecutionPolicy Bypass -File "%SCRIPT_DIR%simple-apk-installer.ps1" -ApkPath "%APK_PATH%"

endlocal
exit /b %errorlevel%
