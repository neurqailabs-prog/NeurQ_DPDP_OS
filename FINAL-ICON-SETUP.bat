@echo off
REM Final Icon Setup - Complete Solution

echo ========================================
echo QS-DPDP OS - Final Icon Setup
echo ========================================
echo.

set ICON_FILE=%~dp0QS-DPDP-OS-Icon.ico
set DESKTOP=%USERPROFILE%\Desktop
set SHORTCUT=%DESKTOP%\QS-DPDP OS.lnk

echo [Step 1/3] Creating custom icon...
if exist "%ICON_FILE%" (
    echo   ✅ Icon file already exists
    goto :update_shortcut
)

echo   Generating icon...
powershell -ExecutionPolicy Bypass -File "create-icon-ps.ps1" >nul 2>&1

if exist "%ICON_FILE%" (
    echo   ✅ Icon created successfully!
) else if exist "QS-DPDP-OS-Icon.png" (
    echo   ⚠️  PNG created, but ICO conversion needed
    echo.
    echo   Please convert PNG to ICO:
    echo   1. Go to: https://convertio.co/png-ico/
    echo   2. Upload: QS-DPDP-OS-Icon.png
    echo   3. Download and save as: QS-DPDP-OS-Icon.ico
    echo   4. Run this script again
    echo.
    start "" "https://convertio.co/png-ico/"
    start "" "QS-DPDP-OS-Icon.png"
    pause
    exit /b 0
) else (
    echo   ❌ Icon creation failed
    echo   Using HTML generator instead...
    start "" "create-custom-icon.html"
    echo.
    echo   Please:
    echo   1. Download icon from browser
    echo   2. Convert to ICO format
    echo   3. Save as: QS-DPDP-OS-Icon.ico
    echo   4. Run this script again
    pause
    exit /b 1
)

:update_shortcut
echo.
echo [Step 2/3] Updating desktop shortcut...
if not exist "%SHORTCUT%" (
    echo   ⚠️  Shortcut not found, creating it...
    call create-desktop-shortcut.bat
)

(
echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
echo sLinkFile = "%SHORTCUT%"
echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
echo oLink.TargetPath = "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS\launch.bat"
echo oLink.WorkingDirectory = "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS"
echo oLink.Description = "Quantum-Safe DPDP Compliance Operating System"
echo oLink.IconLocation = "%ICON_FILE%"
echo oLink.Save
echo WScript.Echo "Icon updated!"
) > "%TEMP%\update_icon_final.vbs"

cscript //nologo "%TEMP%\update_icon_final.vbs" >nul

if %ERRORLEVEL% EQU 0 (
    echo   ✅ Shortcut updated with custom icon!
) else (
    echo   ❌ Error updating shortcut
)

del "%TEMP%\update_icon_final.vbs" >nul 2>&1

echo.
echo [Step 3/3] Verifying...
if exist "%ICON_FILE%" (
    echo   ✅ Icon file: %ICON_FILE%
) else (
    echo   ❌ Icon file missing
)

if exist "%SHORTCUT%" (
    echo   ✅ Desktop shortcut: %SHORTCUT%
) else (
    echo   ❌ Desktop shortcut missing
)

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo Next steps:
echo   1. Press F5 on your desktop to refresh
echo   2. Look for "QS-DPDP OS" icon
echo   3. The icon should show:
echo      - Multi-color "QS" text (Google style)
echo      - "DPDP OS" at bottom
echo      - Quantum-safe theme
echo      - AI badge
echo.
echo If icon doesn't appear:
echo   - Refresh desktop (F5)
echo   - Check desktop view settings
echo   - Sort icons by name
echo.
pause
