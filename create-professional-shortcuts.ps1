# ========================================
# Professional Shortcut Creator
# Creates properly configured desktop shortcuts
# ========================================

param(
    [string]$ProjectDir = "D:\NeurQ_DPDP_Cursor_15012026",
    [string]$IconFile = "QS-DPDP-OS-Icon.ico"
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Creating Professional Desktop Shortcuts" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Define products
$products = @(
    @{
        Name = "QS-DPDP Core"
        Target = "$env:LOCALAPPDATA\NeurQ\QS-DPDP-Core\launch.bat"
        Icon = "$ProjectDir\$IconFile"
        WorkingDir = "$env:LOCALAPPDATA\NeurQ\QS-DPDP-Core"
    },
    @{
        Name = "QS-SIEM"
        Target = "$env:LOCALAPPDATA\NeurQ\QS-SIEM\launch.bat"
        Icon = "$ProjectDir\$IconFile"
        WorkingDir = "$env:LOCALAPPDATA\NeurQ\QS-SIEM"
    },
    @{
        Name = "QS-DLP"
        Target = "$env:LOCALAPPDATA\NeurQ\QS-DLP\launch.bat"
        Icon = "$ProjectDir\$IconFile"
        WorkingDir = "$env:LOCALAPPDATA\NeurQ\QS-DLP"
    },
    @{
        Name = "QS-PII Scanner"
        Target = "$env:LOCALAPPDATA\NeurQ\QS-PII-Scanner\launch.bat"
        Icon = "$ProjectDir\$IconFile"
        WorkingDir = "$env:LOCALAPPDATA\NeurQ\QS-PII-Scanner"
    },
    @{
        Name = "Policy Engine"
        Target = "$env:LOCALAPPDATA\NeurQ\Policy-Engine\launch.bat"
        Icon = "$ProjectDir\$IconFile"
        WorkingDir = "$env:LOCALAPPDATA\NeurQ\Policy-Engine"
    },
    @{
        Name = "QS-DPDP OS"
        Target = "$env:LOCALAPPDATA\NeurQ\QS-DPDP-OS\launch.bat"
        Icon = "$ProjectDir\$IconFile"
        WorkingDir = "$env:LOCALAPPDATA\NeurQ\QS-DPDP-OS"
    }
)

$desktop = [Environment]::GetFolderPath("Desktop")
$shell = New-Object -ComObject WScript.Shell

$successCount = 0
$failCount = 0

foreach ($product in $products) {
    $shortcutPath = Join-Path $desktop "$($product.Name).lnk"
    
    try {
        Write-Host "Creating shortcut: $($product.Name)..." -ForegroundColor Yellow
        
        # Normalize paths
        $shortcutPath = [System.IO.Path]::GetFullPath($shortcutPath)
        $targetPath = [System.IO.Path]::GetFullPath($product.Target)
        $workingDir = [System.IO.Path]::GetFullPath($product.WorkingDir)
        $iconPath = if ($product.Icon) { [System.IO.Path]::GetFullPath($product.Icon) } else { $null }
        
        # Remove existing shortcut
        if (Test-Path $shortcutPath) {
            Remove-Item $shortcutPath -Force -ErrorAction SilentlyContinue
        }
        
        # Verify target exists
        if (-not (Test-Path $targetPath)) {
            Write-Host "  ⚠️  Target not found: $targetPath" -ForegroundColor Yellow
            Write-Host "      Skipping..." -ForegroundColor Yellow
            $failCount++
            continue
        }
        
        # Create shortcut
        $shortcut = $shell.CreateShortcut($shortcutPath)
        $shortcut.TargetPath = $targetPath
        $shortcut.WorkingDirectory = $workingDir
        $shortcut.Description = "Quantum-Safe DPDP Compliance System - $($product.Name)"
        
        # Set icon if file exists
        if ($iconPath -and (Test-Path $iconPath)) {
            $shortcut.IconLocation = "$iconPath,0"
            Write-Host "  ✅ Icon set: $iconPath" -ForegroundColor Green
        } else {
            Write-Host "  ⚠️  Icon not found, using default" -ForegroundColor Yellow
        }
        
        $shortcut.Save()
        
        if (Test-Path $shortcutPath) {
            Write-Host "  ✅ Shortcut created: $shortcutPath" -ForegroundColor Green
            $successCount++
        } else {
            Write-Host "  ❌ Failed to create shortcut" -ForegroundColor Red
            $failCount++
        }
        
    } catch {
        Write-Host "  ❌ Error: $_" -ForegroundColor Red
        Write-Host "     Stack: $($_.Exception.StackTrace)" -ForegroundColor Gray
        $failCount++
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ✅ Created: $successCount" -ForegroundColor Green
Write-Host "  ❌ Failed: $failCount" -ForegroundColor $(if($failCount -gt 0){'Red'}else{'Green'})
Write-Host ""

if ($successCount -gt 0) {
    Write-Host "Shortcuts created successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Refresh desktop (Press F5)" -ForegroundColor White
    Write-Host "  2. Check desktop for shortcuts" -ForegroundColor White
    Write-Host "  3. Double-click any shortcut to test" -ForegroundColor White
    Write-Host ""
}
