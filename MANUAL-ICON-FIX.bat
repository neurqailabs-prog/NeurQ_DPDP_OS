@echo off
REM Manual Icon Fix - Step by Step Guide

echo ========================================
echo QS-DPDP OS - Manual Icon Fix
echo ========================================
echo.

set ICON_FILE=%~dp0QS-DPDP-OS-Icon.ico
set DESKTOP=%USERPROFILE%\Desktop
set SHORTCUT=%DESKTOP%\QS-DPDP OS.lnk

echo The icon file exists and shortcut is updated.
echo.
echo However, Windows sometimes needs manual refresh.
echo.
echo FOLLOW THESE STEPS:
echo.
echo ========================================
echo STEP 1: Open Desktop Folder
echo ========================================
echo.
echo Opening your desktop folder now...
start "" "%DESKTOP%"
timeout /t 2 /nobreak >nul

echo.
echo ========================================
echo STEP 2: Manual Icon Application
echo ========================================
echo.
echo In the desktop folder window that just opened:
echo.
echo   1. Find "QS-DPDP OS.lnk" file
echo   2. RIGHT-CLICK on it
echo   3. Select "Properties"
echo   4. Click "Change Icon" button (at bottom)
echo   5. Click "Browse" button
echo   6. Navigate to: %CD%
echo   7. Select: QS-DPDP-OS-Icon.ico
echo   8. Click "Open"
echo   9. Click "OK"
echo  10. Click "OK" again
echo.
echo ========================================
echo STEP 3: Refresh Desktop
echo ========================================
echo.
echo After applying icon:
echo   - Press F5 on your desktop
echo   - Or right-click desktop ^> Refresh
echo.
echo ========================================
echo Icon File Location:
echo ========================================
echo %ICON_FILE%
echo.
echo Copy this path if needed for browsing.
echo.
pause

REM Clear icon cache
echo.
echo Clearing Windows icon cache...
ie4uinit.exe -show >nul 2>&1

echo.
echo Done! The icon should now appear.
echo.
pause
