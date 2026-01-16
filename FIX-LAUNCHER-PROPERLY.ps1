# Fix Launcher Properly - PowerShell Script
# This will fix all launchers and shortcuts correctly

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Fixing All Launchers Properly" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$products = @(
    @{Name="QS-DPDP Core"; Dir="$env:LOCALAPPDATA\NeurQ\QS-DPDP-Core"},
    @{Name="QS-SIEM"; Dir="$env:LOCALAPPDATA\NeurQ\QS-SIEM"},
    @{Name="QS-DLP"; Dir="$env:LOCALAPPDATA\NeurQ\QS-DLP"},
    @{Name="QS-PII Scanner"; Dir="$env:LOCALAPPDATA\NeurQ\QS-PII-Scanner"},
    @{Name="Policy Engine"; Dir="$env:LOCALAPPDATA\NeurQ\Policy-Engine"},
    @{Name="QS-DPDP OS"; Dir="$env:LOCALAPPDATA\NeurQ\QS-DPDP-OS"}
)

$iconFile = Join-Path $PSScriptRoot "QS-DPDP-OS-Icon.ico"
$desktop = [Environment]::GetFolderPath("Desktop")

foreach ($product in $products) {
    $installDir = $product.Dir
    $productName = $product.Name
    
    Write-Host "Processing: $productName" -ForegroundColor Yellow
    
    # Ensure directory exists
    if (-not (Test-Path $installDir)) {
        New-Item -ItemType Directory -Path $installDir -Force | Out-Null
    }
    
    # Create batch launcher
    $batFile = Join-Path $installDir "launch.bat"
    $batContent = @"
@echo off
cd /d "$installDir"
echo.
echo ========================================
echo $productName
echo ========================================
echo.
where java >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✅ Java found
    java -version
) else (
    echo ❌ Java not found
    echo Please install Java 21+ from https://adoptium.net/
    pause
    exit /b 1
)
echo.
set FOUND=0
if exist "*.jar" (
    for %%F in (*.jar) do (
        if !FOUND! EQU 0 (
            echo Launching %%F...
            java -jar "%%F"
            set FOUND=1
        )
    )
)
if !FOUND! EQU 0 (
    echo ⚠️  Application files not found
    echo Opening installation directory...
    start "" "$installDir"
)
pause
"@
    
    Set-Content -Path $batFile -Value $batContent -Encoding ASCII
    Write-Host "  ✅ Created: launch.bat" -ForegroundColor Green
    
    # Create VBScript launcher (FIXED - no double quotes)
    $vbsFile = Join-Path $installDir "launch.vbs"
    $vbsContent = @"
Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

InstallDir = "$installDir"
Launcher = InstallDir & "\launch.bat"

If fso.FileExists(Launcher) Then
    WshShell.CurrentDirectory = InstallDir
    WshShell.Run "cmd /c """ & Launcher & """", 1, False
Else
    MsgBox "Launcher not found", vbCritical, "$productName"
End If
"@
    
    Set-Content -Path $vbsFile -Value $vbsContent -Encoding ASCII
    Write-Host "  ✅ Created: launch.vbs (FIXED)" -ForegroundColor Green
    
    # Create shortcut pointing DIRECTLY to batch file
    $shortcutPath = Join-Path $desktop "$productName.lnk"
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = $batFile
    $Shortcut.WorkingDirectory = $installDir
    $Shortcut.Description = $productName
    if (Test-Path $iconFile) {
        $Shortcut.IconLocation = "$iconFile,0"
    }
    $Shortcut.Save()
    Write-Host "  ✅ Created shortcut: $productName.lnk" -ForegroundColor Green
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Green
Write-Host "✅ ALL LAUNCHERS FIXED!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Shortcuts now point DIRECTLY to .bat files" -ForegroundColor Yellow
Write-Host ""
Write-Host "Please:" -ForegroundColor Cyan
Write-Host "  1. Press F5 on desktop to refresh" -ForegroundColor White
Write-Host "  2. Double-click any shortcut" -ForegroundColor White
Write-Host "  3. It should work now!" -ForegroundColor White
Write-Host ""
