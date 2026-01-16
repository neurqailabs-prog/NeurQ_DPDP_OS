@echo off
REM ========================================
REM Uninstall All Products - Complete Cleanup
REM ========================================

setlocal enabledelayedexpansion

echo.
echo ========================================
echo UNINSTALLING ALL PRODUCTS
echo ========================================
echo.
echo This will remove:
echo   - All installed products
echo   - All desktop shortcuts
echo   - All Start Menu entries
echo   - All installation directories
echo.
echo Press Ctrl+C to cancel, or
pause

echo.
echo [Step 1/4] Removing desktop shortcuts...
set DESKTOP=%USERPROFILE%\Desktop

for %%S in (
    "QS-DPDP Core.lnk"
    "QS-SIEM.lnk"
    "QS-DLP.lnk"
    "QS-PII Scanner.lnk"
    "Policy Engine.lnk"
    "QS-DPDP OS.lnk"
) do (
    set SHORTCUT=%DESKTOP%\%%S
    if exist !SHORTCUT! (
        del /F /Q !SHORTCUT! >nul 2>&1
        echo   ✅ Removed: %%S
    )
)
echo.

echo [Step 2/4] Removing Start Menu entries...
set START_MENU=%APPDATA%\Microsoft\Windows\Start Menu\Programs\NeurQ

if exist "%START_MENU%" (
    rmdir /S /Q "%START_MENU%" >nul 2>&1
    echo   ✅ Removed Start Menu entries
) else (
    echo   ℹ️  No Start Menu entries found
)
echo.

echo [Step 3/4] Removing installation directories...
for %%D in (
    "%LOCALAPPDATA%\NeurQ\QS-DPDP-Core"
    "%LOCALAPPDATA%\NeurQ\QS-SIEM"
    "%LOCALAPPDATA%\NeurQ\QS-DLP"
    "%LOCALAPPDATA%\NeurQ\QS-PII-Scanner"
    "%LOCALAPPDATA%\NeurQ\Policy-Engine"
    "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS"
) do (
    if exist "%%D" (
        rmdir /S /Q "%%D" >nul 2>&1
        echo   ✅ Removed: %%~nxD
    )
)
echo.

echo [Step 4/4] Removing registry entries...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\QS-DPDP Core" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\QS-SIEM" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\QS-DLP" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\QS-PII Scanner" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\Policy Engine" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\QS-DPDP OS" /f >nul 2>&1
echo   ✅ Registry entries removed
echo.

echo ========================================
echo ✅ UNINSTALLATION COMPLETE
echo ========================================
echo.
echo All products have been uninstalled.
echo System is now clean and ready for fresh installation.
echo.
pause
