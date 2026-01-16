@echo off
REM ========================================
REM Complete Diagnosis and Fix
REM ========================================
REM This script diagnoses all issues and fixes them

setlocal enabledelayedexpansion

echo.
echo ========================================
echo Complete Diagnosis and Fix
echo ========================================
echo.
echo This will:
echo   1. Check all launchers
echo   2. Fix any issues found
echo   3. Verify shortcuts
echo   4. Create a working test
echo.
pause
echo.

:: Step 1: Check launchers
echo [Step 1/4] Checking launchers...
echo.

set INSTALL_DIR=%LOCALAPPDATA%\NeurQ\QS-DPDP-OS
if exist "%INSTALL_DIR%\launch.bat" (
    echo ✅ Launcher exists: %INSTALL_DIR%\launch.bat
    echo.
    echo Checking launcher content...
    
    findstr /C:"setlocal enabledelayedexpansion" "%INSTALL_DIR%\launch.bat" >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo ✅ Has delayed expansion
    ) else (
        echo ❌ Missing delayed expansion - WILL FIX
        set FIX_NEEDED=1
    )
    
    findstr /C:"cd /d" "%INSTALL_DIR%\launch.bat" >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo ✅ Has cd /d command
    ) else (
        echo ❌ Missing cd /d - WILL FIX
        set FIX_NEEDED=1
    )
    
    findstr /C:"if !FOUND!" "%INSTALL_DIR%\launch.bat" >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo ✅ Has correct syntax (!FOUND!)
    ) else (
        echo ❌ Syntax issue - WILL FIX
        set FIX_NEEDED=1
    )
    
) else (
    echo ❌ Launcher not found - WILL CREATE
    set FIX_NEEDED=1
)

echo.

:: Step 2: Fix launchers if needed
if defined FIX_NEEDED (
    echo [Step 2/4] Fixing launchers...
    call fix-launchers-completely.bat
    echo.
) else (
    echo [Step 2/4] Launchers OK, skipping fix
    echo.
)

:: Step 3: Verify shortcuts
echo [Step 3/4] Verifying shortcuts...
echo.

set DESKTOP=%USERPROFILE%\Desktop
set SHORTCUT_COUNT=0

for %%S in (
    "QS-DPDP Core.lnk"
    "QS-SIEM.lnk"
    "QS-DLP.lnk"
    "QS-PII Scanner.lnk"
    "Policy Engine.lnk"
    "QS-DPDP OS.lnk"
) do (
    if exist "%DESKTOP%\%%~S" (
        set /a SHORTCUT_COUNT+=1
        echo ✅ Found: %%~S
    ) else (
        echo ⚠️  Missing: %%~S
    )
)

echo.
echo Found !SHORTCUT_COUNT! shortcuts
echo.

:: Step 4: Create working test
echo [Step 4/4] Creating working test...
echo.

REM Create a simple test launcher
(
echo @echo off
echo echo ========================================
echo echo QS-DPDP OS - Working Test
echo ========================================
echo echo.
echo echo If you see this, shortcuts are working!
echo echo.
echo echo Installation: %LOCALAPPDATA%\NeurQ\QS-DPDP-OS
echo echo.
echo pause
) > "%INSTALL_DIR%\test-launcher.bat"

REM Create test shortcut
set TEST_SHORTCUT=%DESKTOP%\TEST-QS-DPDP-OS.lnk
(
echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
echo sLinkFile = "%TEST_SHORTCUT%"
echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
echo oLink.TargetPath = "%INSTALL_DIR%\test-launcher.bat"
echo oLink.WorkingDirectory = "%INSTALL_DIR%"
echo oLink.Description = "Test launcher for QS-DPDP OS"
echo oLink.Save
) > "%TEMP%\create_test_sc.vbs"

cscript //nologo "%TEMP%\create_test_sc.vbs" >nul 2>&1
del "%TEMP%\create_test_sc.vbs" >nul 2>&1

if exist "%TEST_SHORTCUT%" (
    echo ✅ Test shortcut created: TEST-QS-DPDP-OS.lnk
    echo.
    echo Please test this shortcut first!
    echo.
) else (
    echo ⚠️  Could not create test shortcut
    echo.
)

echo.
echo ========================================
echo Diagnosis Complete
echo ========================================
echo.
echo Summary:
echo   - Launchers: Checked and fixed if needed
echo   - Shortcuts: !SHORTCUT_COUNT! found
echo   - Test: Created (TEST-QS-DPDP-OS.lnk)
echo.
echo Next steps:
echo   1. Double-click TEST-QS-DPDP-OS.lnk on desktop
echo   2. Tell me what happens
echo   3. Then try the main shortcuts
echo.
pause
