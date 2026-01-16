@echo off
REM Force Icon Fix - Complete Rebuild

echo ========================================
echo QS-DPDP OS - FORCE ICON FIX
echo ========================================
echo.

set ICON_FILE=%~dp0QS-DPDP-OS-Icon.ico
set DESKTOP=%USERPROFILE%\Desktop
set SHORTCUT=%DESKTOP%\QS-DPDP OS.lnk
set INSTALL_DIR=%LOCALAPPDATA%\NeurQ\QS-DPDP-OS

echo [Step 1] Deleting old shortcut...
if exist "%SHORTCUT%" (
    del "%SHORTCUT%" >nul 2>&1
    echo   ✅ Old shortcut deleted
)

echo.
echo [Step 2] Creating fresh shortcut...
(
echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
echo sLinkFile = "%SHORTCUT%"
echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
echo oLink.TargetPath = "%INSTALL_DIR%\launch.bat"
echo oLink.WorkingDirectory = "%INSTALL_DIR%"
echo oLink.Description = "Quantum-Safe DPDP Compliance Operating System"
) > "%TEMP%\create_shortcut.vbs"

cscript //nologo "%TEMP%\create_shortcut.vbs" >nul
del "%TEMP%\create_shortcut.vbs" >nul 2>&1

if exist "%SHORTCUT%" (
    echo   ✅ New shortcut created
) else (
    echo   ❌ Failed to create shortcut
    pause
    exit /b 1
)

echo.
echo [Step 3] Copying icon to accessible location...
set ICON_COPY=%DESKTOP%\QS-DPDP-Icon.ico
if exist "%ICON_FILE%" (
    copy "%ICON_FILE%" "%ICON_COPY%" >nul 2>&1
    echo   ✅ Icon copied to desktop: %ICON_COPY%
    set ICON_TO_USE=%ICON_COPY%
) else (
    echo   ⚠️  Original icon not found, will use default
    set ICON_TO_USE=
)

echo.
echo [Step 4] Applying icon to shortcut...
if defined ICON_TO_USE (
    (
    echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
    echo sLinkFile = "%SHORTCUT%"
    echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
    echo oLink.IconLocation = "%ICON_TO_USE%,0"
    echo oLink.Save
    echo WScript.Echo "Icon applied!"
    ) > "%TEMP%\apply_icon.vbs"
    cscript //nologo "%TEMP%\apply_icon.vbs" >nul
    del "%TEMP%\apply_icon.vbs" >nul 2>&1
    echo   ✅ Icon applied: %ICON_TO_USE%
) else (
    echo   ⚠️  Using default icon
)

echo.
echo [Step 5] Refreshing desktop...
REM Force desktop refresh
taskkill /F /IM explorer.exe >nul 2>&1
timeout /t 1 /nobreak >nul
start explorer.exe
timeout /t 2 /nobreak >nul

echo   ✅ Desktop refreshed

echo.
echo [Step 6] Opening desktop folder...
start "" "%DESKTOP%"
echo   ✅ Desktop folder opened

echo.
echo ========================================
echo COMPLETE!
echo ========================================
echo.
echo The desktop folder is now open.
echo.
echo Look for: "QS-DPDP OS.lnk"
echo.
echo If the icon STILL doesn't show:
echo.
echo MANUAL METHOD (100%% Works):
echo   1. In the desktop folder, find "QS-DPDP OS.lnk"
echo   2. RIGHT-CLICK it
echo   3. Click "Properties"
echo   4. Click "Change Icon" button
echo   5. Click "Browse"
echo   6. In the desktop folder, select: "QS-DPDP-Icon.ico"
echo      (This file is now on your desktop too!)
echo   7. Click "Open" → "OK" → "OK"
echo   8. Press F5 on desktop
echo.
echo Icon file is now on your desktop for easy access!
echo.
pause
