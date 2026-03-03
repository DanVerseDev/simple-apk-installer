# Simple APK Installer - Core Logic v1.2
# Author: DanVerseDev
# Description: Automates APK installation into WSA with robust ADB connection and UTF8.

param (
    [Parameter(Mandatory=$true)]
    [string]$ApkPath
)

# --- Environment Setup ---
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# --- Configuration ---
$WsaPackageId = "MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe!App"
$AdbAddress = "localhost:58526"
$MaxAdbWaitSeconds = 60
$LangDir = Join-Path $PSScriptRoot "lang"
$DefaultCulture = "en-US"

# --- Multi-language Helper ---
function Get-Translation {
    param(
        [string]$Key,
        [object[]]$Values
    )
    
    $currentCulture = [System.Globalization.CultureInfo]::CurrentCulture.Name
    $langFile = Join-Path $LangDir "$currentCulture.json"
    
    if (-not (Test-Path $langFile)) {
        $shortCulture = $currentCulture.Split('-')[0]
        $matchingFiles = Get-ChildItem -Path $LangDir -Filter "$shortCulture*.json" | Select-Object -First 1
        if ($matchingFiles) {
            $langFile = $matchingFiles.FullName
        } else {
            $langFile = Join-Path $LangDir "$DefaultCulture.json"
        }
    }
    
    if (-not (Test-Path $langFile)) { return "[$Key]" }
    
    # Explicitly read JSON content as UTF8
    try {
        $rawJson = [System.IO.File]::ReadAllText($langFile, [System.Text.Encoding]::UTF8)
        $translations = $rawJson | ConvertFrom-Json
        $text = $translations.$Key
    } catch {
        return "[$Key]"
    }
    
    if ($null -eq $text) { return "[$Key]" }
    if ($null -ne $Values -and $Values.Count -gt 0) {
        return $text -f $Values
    }
    return $text
}

function Show-Branding {
    Write-Host (Get-Translation "app_title") -ForegroundColor Cyan
    Write-Host (Get-Translation "github_link") -ForegroundColor Gray
    Write-Host (Get-Translation "donate_link") -ForegroundColor Yellow
    Write-Host "-------------------------------------------"
}

# --- Initialization ---
Show-Branding
Write-Host (Get-Translation "target_apk" @($ApkPath))

if (-not (Test-Path $ApkPath)) {
    Write-Host (Get-Translation "error_apk_not_found" @($ApkPath)) -ForegroundColor Red
    Read-Host (Get-Translation "press_key")
    exit 1
}

# --- Locate ADB ---
$AdbPath = "adb"
if (-not (Get-Command adb -ErrorAction SilentlyContinue)) {
    Write-Host (Get-Translation "error_adb_missing") -ForegroundColor Red
    Read-Host (Get-Translation "press_key")
    exit 1
}

# --- WSA Activation ---
function Activate-WSA {
    # We use explorer to launch the WSA Settings app which reliably wakes up the subsystem
    Start-Process "explorer.exe" -ArgumentList "shell:AppsFolder\$WsaPackageId"
}

$wsaProcess = Get-Process -Name "vmmemWSA","WsaClient","WsaService" -ErrorAction SilentlyContinue
if (-not $wsaProcess) {
    Activate-WSA
}

# --- Wait for ADB ---
Write-Host (Get-Translation "waiting_adb" @($AdbAddress)) -ForegroundColor Cyan
$start = Get-Date
$adbReady = $false

# Force server restart if it might be hung
& $AdbPath start-server | Out-Null

$lastWakeUp = $start
while (((Get-Date) - $start).TotalSeconds -lt $MaxAdbWaitSeconds) {
    # Periodically re-activate WSA if ADB is silent
    $elapsedSinceWake = ((Get-Date) - $lastWakeUp).TotalSeconds
    if ($elapsedSinceWake -gt 15) {
        Activate-WSA
        $lastWakeUp = Get-Date
    }
    
    # Always try to connect
    & $AdbPath connect $AdbAddress | Out-Null
    
    # Check status
    $devices = & $AdbPath devices 2>$null
    
    if ($devices -match "$AdbAddress\s+device") {
        # Check if system is actually fully booted (Package Manager service ready)
        Write-Host (Get-Translation "wsa_booting") -ForegroundColor Yellow
        $bootStatus = & $AdbPath -s $AdbAddress shell getprop sys.boot_completed 2>$null
        if ($bootStatus -match "1") {
            $adbReady = $true
            break
        }
    }
    
    if ($devices -match "$AdbAddress\s+unauthorized") {
        Write-Host "!" -ForegroundColor Yellow -NoNewline
    } else {
        Write-Host "." -NoNewline
    }
    
    Start-Sleep -Seconds 2
}
Write-Host ""

if (-not $adbReady) {
    Write-Host (Get-Translation "wsa_timeout" @($AdbAddress, $MaxAdbWaitSeconds)) -ForegroundColor Red
    Write-Host (Get-Translation "dev_mode_hint") -ForegroundColor Yellow
    Read-Host (Get-Translation "press_key")
    exit 1
}

Write-Host (Get-Translation "wsa_ready") -ForegroundColor Green

# --- Install ---
Write-Host (Get-Translation "installing") -ForegroundColor Cyan
$installResult = & $AdbPath -s $AdbAddress install "$ApkPath" 2>&1

if ($installResult -match "Success") {
    Write-Host (Get-Translation "success") -ForegroundColor Green
}
elseif ($installResult -match "INSTALL_FAILED_UPDATE_INCOMPATIBLE") {
    Write-Host (Get-Translation "signature_mismatch") -ForegroundColor Red
}
elseif ($installResult -match "unauthorized") {
    Write-Host (Get-Translation "unauthorized") -ForegroundColor Red
}
else {
    Write-Host (Get-Translation "failed") -ForegroundColor Red
    $installResult | ForEach-Object { Write-Host "    $_" -ForegroundColor Gray }
}

Write-Host (Get-Translation "completed") -ForegroundColor Cyan
Read-Host (Get-Translation "press_key")