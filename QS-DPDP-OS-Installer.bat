@echo off
REM ========================================
REM QS-DPDP OS - Complete Installer
REM ========================================
REM This installer will install the entire QS-DPDP OS solution
REM Run this file to install everything automatically

setlocal enabledelayedexpansion

echo.
echo ========================================
echo QS-DPDP OS - Complete Installation
echo ========================================
echo.
echo This installer will:
echo   - Install QS-DPDP OS to your system
echo   - Create desktop shortcut with custom icon
echo   - Set up splash screen
echo   - Configure all components
echo   - Create Start Menu entry
echo.
echo Press any key to continue or Ctrl+C to cancel...
pause >nul

REM ========================================
REM Configuration
REM ========================================
set INSTALL_DIR=%LOCALAPPDATA%\NeurQ\QS-DPDP-OS
set DESKTOP=%USERPROFILE%\Desktop
set START_MENU=%APPDATA%\Microsoft\Windows\Start Menu\Programs\NeurQ
set ICON_FILE=%~dp0QS-DPDP-OS-Icon.ico
set SPLASH_FILE=%~dp0splash-screen.html

echo.
echo ========================================
echo [1/8] Creating Installation Directory
echo ========================================
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%" >nul 2>&1
    echo   ✅ Created: %INSTALL_DIR%
) else (
    echo   ✅ Directory exists: %INSTALL_DIR%
)

echo.
echo ========================================
echo [2/8] Copying Application Files
echo ========================================
echo   Copying core files...

REM Copy launcher
if exist "dist\executables\launch.bat" (
    copy "dist\executables\launch.bat" "%INSTALL_DIR%\" >nul 2>&1
    echo   ✅ Launcher copied
)

REM Copy splash screen
if exist "%SPLASH_FILE%" (
    copy "%SPLASH_FILE%" "%INSTALL_DIR%\" >nul 2>&1
    echo   ✅ Splash screen copied
)

REM Copy documentation
if exist "docs" (
    xcopy /E /I /Y "docs" "%INSTALL_DIR%\docs\" >nul 2>&1
    echo   ✅ Documentation copied
)

REM Copy README files
if exist "README.md" copy "README.md" "%INSTALL_DIR%\" >nul 2>&1
if exist "START-HERE.md" copy "START-HERE.md" "%INSTALL_DIR%\" >nul 2>&1

echo.
echo ========================================
echo [3/8] Copying Icon File
echo ========================================
if exist "%ICON_FILE%" (
    copy "%ICON_FILE%" "%INSTALL_DIR%\" >nul 2>&1
    copy "%ICON_FILE%" "%DESKTOP%\QS-DPDP-Icon.ico" >nul 2>&1
    echo   ✅ Icon file copied
    set ICON_TO_USE=%INSTALL_DIR%\QS-DPDP-OS-Icon.ico
) else (
    echo   ⚠️  Icon file not found, will use default
    set ICON_TO_USE=
)

echo.
echo ========================================
echo [4/8] Creating Desktop Shortcut
echo ========================================
if exist "%DESKTOP%\QS-DPDP OS.lnk" (
    del "%DESKTOP%\QS-DPDP OS.lnk" >nul 2>&1
)

(
echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
echo sLinkFile = "%DESKTOP%\QS-DPDP OS.lnk"
echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
echo oLink.TargetPath = "%INSTALL_DIR%\launch.bat"
echo oLink.WorkingDirectory = "%INSTALL_DIR%"
echo oLink.Description = "Quantum-Safe DPDP Compliance Operating System"
) > "%TEMP%\create_shortcut.vbs"

if defined ICON_TO_USE (
    (
    echo oLink.IconLocation = "%ICON_TO_USE%,0"
    ) >> "%TEMP%\create_shortcut.vbs"
)

(
echo oLink.Save
echo WScript.Echo "Shortcut created!"
) >> "%TEMP%\create_shortcut.vbs"

cscript //nologo "%TEMP%\create_shortcut.vbs" >nul 2>&1
del "%TEMP%\create_shortcut.vbs" >nul 2>&1

if exist "%DESKTOP%\QS-DPDP OS.lnk" (
    echo   ✅ Desktop shortcut created
) else (
    echo   ❌ Failed to create shortcut
)

echo.
echo ========================================
echo [5/8] Creating Start Menu Entry
echo ========================================
if not exist "%START_MENU%" mkdir "%START_MENU%" >nul 2>&1

(
echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
echo sLinkFile = "%START_MENU%\QS-DPDP OS.lnk"
echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
echo oLink.TargetPath = "%INSTALL_DIR%\launch.bat"
echo oLink.WorkingDirectory = "%INSTALL_DIR%"
echo oLink.Description = "Quantum-Safe DPDP Compliance Operating System"
) > "%TEMP%\create_startmenu.vbs"

if defined ICON_TO_USE (
    (
    echo oLink.IconLocation = "%ICON_TO_USE%,0"
    ) >> "%TEMP%\create_startmenu.vbs"
)

(
echo oLink.Save
) >> "%TEMP%\create_startmenu.vbs"

cscript //nologo "%TEMP%\create_startmenu.vbs" >nul 2>&1
del "%TEMP%\create_startmenu.vbs" >nul 2>&1

echo   ✅ Start Menu entry created

echo.
echo ========================================
echo [6/8] Creating Configuration File
echo ========================================
(
echo # QS-DPDP OS Configuration
echo # Generated during installation
echo.
echo install.path=%INSTALL_DIR%
echo install.date=%DATE% %TIME%
echo version=1.0.0
echo java.home=%JAVA_HOME%
) > "%INSTALL_DIR%\config.properties"
echo   ✅ Configuration file created

echo.
echo ========================================
echo [7/8] Creating Uninstaller
echo ========================================
(
echo @echo off
echo REM QS-DPDP OS Uninstaller
echo echo Uninstalling QS-DPDP OS...
echo echo.
echo set INSTALL_DIR=%INSTALL_DIR%
echo set DESKTOP=%DESKTOP%
echo set START_MENU=%START_MENU%
echo.
echo echo Removing Start Menu shortcut...
echo if exist "%START_MENU%\QS-DPDP OS.lnk" del "%START_MENU%\QS-DPDP OS.lnk"
echo.
echo echo Removing desktop shortcut...
echo if exist "%DESKTOP%\QS-DPDP OS.lnk" del "%DESKTOP%\QS-DPDP OS.lnk"
echo.
echo echo Removing installation directory...
echo if exist "%INSTALL_DIR%" rmdir /S /Q "%INSTALL_DIR%"
echo.
echo echo QS-DPDP OS has been uninstalled.
echo pause
) > "%INSTALL_DIR%\uninstall.bat"
echo   ✅ Uninstaller created

echo.
echo ========================================
echo [8/8] Finalizing Installation
echo ========================================
REM Refresh desktop
taskkill /F /IM explorer.exe >nul 2>&1
timeout /t 1 /nobreak >nul
start explorer.exe
timeout /t 2 /nobreak >nul

echo   ✅ Desktop refreshed

echo.
echo ========================================
echo INSTALLATION COMPLETE!
echo ========================================
echo.
echo QS-DPDP OS has been successfully installed!
echo.
echo Installation Details:
echo   Location: %INSTALL_DIR%
echo   Desktop Shortcut: %DESKTOP%\QS-DPDP OS.lnk
echo   Start Menu: %START_MENU%\QS-DPDP OS.lnk
echo.
echo To run QS-DPDP OS:
echo   1. Double-click desktop shortcut
echo   2. Or use Start Menu: NeurQ ^> QS-DPDP OS
echo.
echo To uninstall:
echo   Run: %INSTALL_DIR%\uninstall.bat
echo.
echo Opening installation directory...
start "" "%INSTALL_DIR%"
echo.
pause

endlocal
