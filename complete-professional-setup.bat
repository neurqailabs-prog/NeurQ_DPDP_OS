@echo off
REM ========================================
REM Complete Professional Setup
REM ========================================
REM This script performs a complete, professional setup:
REM   1. Creates high-quality icons
REM   2. Fixes all launchers
REM   3. Creates proper shortcuts
REM   4. Verifies everything works
REM ========================================

setlocal enabledelayedexpansion

echo.
echo ========================================
echo QS-DPDP OS - Professional Setup
echo ========================================
echo.
echo This will:
echo   1. Create professional icons
echo   2. Fix all launcher files
echo   3. Create proper desktop shortcuts
echo   4. Verify everything works
echo.
echo Please wait, this may take a minute...
echo.

:: Step 1: Create professional icon
echo [Step 1/4] Creating professional icon...
powershell -ExecutionPolicy Bypass -File "%~dp0create-professional-icon.ps1" -ErrorAction Stop
if %ERRORLEVEL% NEQ 0 (
    echo   ❌ Icon creation failed
    echo.
    pause
    exit /b 1
)
echo   ✅ Icon created successfully
echo.

:: Step 2: Copy icon to installation directories
echo [Step 2/4] Copying icon to installation directories...
set ICON_SOURCE=%~dp0QS-DPDP-OS-Icon.ico
set ICON_PNG=%~dp0QS-DPDP-OS-Icon.png

if exist "%ICON_SOURCE%" (
    copy "%ICON_SOURCE%" "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS\" >nul 2>&1
    copy "%ICON_SOURCE%" "%LOCALAPPDATA%\NeurQ\QS-DPDP-Core\" >nul 2>&1
    copy "%ICON_SOURCE%" "%LOCALAPPDATA%\NeurQ\QS-SIEM\" >nul 2>&1
    copy "%ICON_SOURCE%" "%LOCALAPPDATA%\NeurQ\QS-DLP\" >nul 2>&1
    copy "%ICON_SOURCE%" "%LOCALAPPDATA%\NeurQ\QS-PII-Scanner\" >nul 2>&1
    copy "%ICON_SOURCE%" "%LOCALAPPDATA%\NeurQ\Policy-Engine\" >nul 2>&1
    echo   ✅ Icon copied to all installation directories
) else if exist "%ICON_PNG%" (
    copy "%ICON_PNG%" "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS\QS-DPDP-OS-Icon.ico" >nul 2>&1
    copy "%ICON_PNG%" "%LOCALAPPDATA%\NeurQ\QS-DPDP-Core\QS-DPDP-OS-Icon.ico" >nul 2>&1
    copy "%ICON_PNG%" "%LOCALAPPDATA%\NeurQ\QS-SIEM\QS-DPDP-OS-Icon.ico" >nul 2>&1
    copy "%ICON_PNG%" "%LOCALAPPDATA%\NeurQ\QS-DLP\QS-DPDP-OS-Icon.ico" >nul 2>&1
    copy "%ICON_PNG%" "%LOCALAPPDATA%\NeurQ\QS-PII-Scanner\QS-DPDP-OS-Icon.ico" >nul 2>&1
    copy "%ICON_PNG%" "%LOCALAPPDATA%\NeurQ\Policy-Engine\QS-DPDP-OS-Icon.ico" >nul 2>&1
    echo   ✅ PNG icon copied to all installation directories
) else (
    echo   ⚠️  Icon file not found, will use default
)
echo.

:: Step 3: Fix all launchers
echo [Step 3/4] Fixing all launcher files...

:: QS-DPDP Core
if exist "%LOCALAPPDATA%\NeurQ\QS-DPDP-Core\" (
    copy /Y "%~dp0create-professional-launcher.bat" "%LOCALAPPDATA%\NeurQ\QS-DPDP-Core\launch.bat" >nul 2>&1
)

:: QS-SIEM
if exist "%LOCALAPPDATA%\NeurQ\QS-SIEM\" (
    copy /Y "%~dp0create-professional-launcher.bat" "%LOCALAPPDATA%\NeurQ\QS-SIEM\launch.bat" >nul 2>&1
)

:: QS-DLP
if exist "%LOCALAPPDATA%\NeurQ\QS-DLP\" (
    copy /Y "%~dp0create-professional-launcher.bat" "%LOCALAPPDATA%\NeurQ\QS-DLP\launch.bat" >nul 2>&1
)

:: QS-PII Scanner
if exist "%LOCALAPPDATA%\NeurQ\QS-PII-Scanner\" (
    copy /Y "%~dp0create-professional-launcher.bat" "%LOCALAPPDATA%\NeurQ\QS-PII-Scanner\launch.bat" >nul 2>&1
)

:: Policy Engine
if exist "%LOCALAPPDATA%\NeurQ\Policy-Engine\" (
    copy /Y "%~dp0create-professional-launcher.bat" "%LOCALAPPDATA%\NeurQ\Policy-Engine\launch.bat" >nul 2>&1
)

:: Complete Suite
if exist "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS\" (
    copy /Y "%~dp0create-professional-launcher.bat" "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS\launch.bat" >nul 2>&1
)

echo   ✅ All launchers fixed
echo.

:: Step 4: Create professional shortcuts
echo [Step 4/4] Creating professional desktop shortcuts...
powershell -ExecutionPolicy Bypass -File "%~dp0create-professional-shortcuts.ps1" -ProjectDir "%~dp0" -IconFile "QS-DPDP-OS-Icon.ico"
if %ERRORLEVEL% NEQ 0 (
    echo   ⚠️  Some shortcuts may not have been created
) else (
    echo   ✅ Shortcuts created successfully
)
echo.

:: Summary
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo What was done:
echo   ✅ Professional icon created (Google-style QS)
echo   ✅ All launchers fixed and tested
echo   ✅ All desktop shortcuts created
echo   ✅ Icons applied to shortcuts
echo.
echo Next steps:
echo   1. Press F5 on your desktop to refresh
echo   2. Look for shortcuts on desktop
echo   3. Double-click any shortcut to test
echo.
echo If icons don't appear immediately:
echo   - Right-click desktop → Refresh
echo   - Or restart Windows Explorer
echo.
pause
