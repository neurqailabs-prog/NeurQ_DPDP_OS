@echo off
REM Refresh Desktop and Show QS-DPDP OS Shortcut

echo ========================================
echo QS-DPDP OS - Desktop Shortcut Helper
echo ========================================
echo.

set DESKTOP=%USERPROFILE%\Desktop
set SHORTCUT=%DESKTOP%\QS-DPDP OS.lnk
set INSTALL_DIR=%LOCALAPPDATA%\NeurQ\QS-DPDP-OS

echo [1/4] Checking shortcut...
if exist "%SHORTCUT%" (
    echo   ✅ Shortcut exists: %SHORTCUT%
) else (
    echo   ❌ Shortcut not found, creating...
    goto :create_shortcut
)

echo [2/4] Verifying shortcut target...
if exist "%INSTALL_DIR%\launch.bat" (
    echo   ✅ Target file exists
) else (
    echo   ❌ Target file not found: %INSTALL_DIR%\launch.bat
    echo   Please check installation.
    pause
    exit /b 1
)

echo [3/4] Refreshing desktop...
REM Refresh desktop by touching desktop.ini or using explorer refresh
taskkill /F /IM explorer.exe >nul 2>&1
start explorer.exe
timeout /t 2 /nobreak >nul
echo   Desktop refreshed

echo [4/4] Opening desktop folder...
start "" "%DESKTOP%"
echo   Desktop folder opened - look for "QS-DPDP OS.lnk"
echo.

echo ========================================
echo Shortcut Information
echo ========================================
echo.
echo Shortcut Name: QS-DPDP OS.lnk
echo Location: %DESKTOP%
echo Target: %INSTALL_DIR%\launch.bat
echo.
echo If you still don't see it:
echo   1. Check if desktop icons are hidden (View menu)
echo   2. Sort desktop icons (Right-click > Sort by > Name)
echo   3. Look for files starting with "QS"
echo.
echo Alternative: Run directly from:
echo   %INSTALL_DIR%\launch.bat
echo.
pause
exit /b 0

:create_shortcut
echo Creating shortcut...
(
echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
echo sLinkFile = "%SHORTCUT%"
echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
echo oLink.TargetPath = "%INSTALL_DIR%\launch.bat"
echo oLink.WorkingDirectory = "%INSTALL_DIR%"
echo oLink.Description = "Quantum-Safe DPDP Compliance Operating System"
echo oLink.IconLocation = "shell32.dll,1"
echo oLink.Save
echo WScript.Echo "Shortcut created!"
) > "%TEMP%\create_shortcut.vbs"
cscript //nologo "%TEMP%\create_shortcut.vbs"
del "%TEMP%\create_shortcut.vbs" >nul 2>&1
goto :eof
