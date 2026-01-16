@echo off
REM Post-Restart Verification Script

echo ========================================
echo QS-DPDP OS - Post-Restart Verification
echo ========================================
echo.

echo [1/4] Checking icon file...
set ICON_FILE=%~dp0QS-DPDP-OS-Icon.ico
if exist "%ICON_FILE%" (
    echo   ✅ Icon file exists: %ICON_FILE%
) else (
    echo   ❌ Icon file missing!
    echo   Run: create-icon-simple.bat
)

echo.
echo [2/4] Checking desktop shortcut...
set SHORTCUT=%USERPROFILE%\Desktop\QS-DPDP OS.lnk
if exist "%SHORTCUT%" (
    echo   ✅ Desktop shortcut exists
) else (
    echo   ❌ Desktop shortcut missing!
    echo   Run: create-desktop-shortcut.bat
)

echo.
echo [3/4] Checking installation...
set INSTALL_DIR=%LOCALAPPDATA%\NeurQ\QS-DPDP-OS
if exist "%INSTALL_DIR%" (
    echo   ✅ Installation directory exists
) else (
    echo   ❌ Installation missing!
)

echo.
echo [4/4] Checking splash screen...
if exist "%INSTALL_DIR%\splash-screen.html" (
    echo   ✅ Splash screen exists
) else (
    echo   ⚠️  Splash screen missing
)

echo.
echo ========================================
echo Verification Complete
echo ========================================
echo.
echo Next steps:
echo   1. Check your desktop for "QS-DPDP OS" icon
echo   2. If icon is visible - SUCCESS! ✅
echo   3. If not visible - run: MANUAL-ICON-FIX.bat
echo   4. Double-click icon to test application
echo.
pause
