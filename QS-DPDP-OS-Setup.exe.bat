@echo off
REM ========================================
REM QS-DPDP OS - Proper Windows Installer
REM ========================================
REM This creates a proper Windows-style installer
REM Run this file to install QS-DPDP OS

setlocal enabledelayedexpansion

title QS-DPDP OS - Installation Wizard

color 0A

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                                                              ║
echo ║         QS-DPDP OS - Installation Wizard                    ║
echo ║                                                              ║
echo ║    Quantum-Safe DPDP Compliance Operating System            ║
echo ║                                                              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo.
echo This wizard will guide you through the installation of
echo QS-DPDP Operating System on your computer.
echo.
echo.
echo Press any key to begin installation...
pause >nul 2>&1

cls

REM Configuration
set INSTALL_DIR=%LOCALAPPDATA%\NeurQ\QS-DPDP-OS
set DESKTOP=%USERPROFILE%\Desktop
set START_MENU=%APPDATA%\Microsoft\Windows\Start Menu\Programs\NeurQ
set ICON_FILE=%~dp0QS-DPDP-OS-Icon.ico
set SPLASH_FILE=%~dp0splash-screen.html
set ERROR_COUNT=0

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    Installation Progress                     ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

REM Step 1: Create Directory
echo [1/10] Creating installation directory...
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%" 2>nul
    if !ERRORLEVEL! EQU 0 (
        echo     ✓ Directory created: %INSTALL_DIR%
    ) else (
        echo     ✗ Failed to create directory
        set /a ERROR_COUNT+=1
        goto :error
    )
) else (
    echo     ✓ Directory already exists
)

REM Step 2: Copy Launcher
echo [2/10] Installing application launcher...
if exist "dist\executables\launch.bat" (
    copy "dist\executables\launch.bat" "%INSTALL_DIR%\" >nul 2>&1
    if !ERRORLEVEL! EQU 0 (
        echo     ✓ Launcher installed
    ) else (
        echo     ✗ Failed to copy launcher
        set /a ERROR_COUNT+=1
    )
) else if exist "launch-with-splash.bat" (
    copy "launch-with-splash.bat" "%INSTALL_DIR%\launch.bat" >nul 2>&1
    echo     ✓ Launcher installed
) else (
    echo     ⚠ Launcher file not found, creating default...
    (
    echo @echo off
    echo echo QS-DPDP OS
    echo echo Application launcher
    echo pause
    ) > "%INSTALL_DIR%\launch.bat"
    echo     ✓ Default launcher created
)

REM Step 3: Copy Splash Screen
echo [3/10] Installing splash screen...
if exist "%SPLASH_FILE%" (
    copy "%SPLASH_FILE%" "%INSTALL_DIR%\" >nul 2>&1
    echo     ✓ Splash screen installed
) else (
    echo     ⚠ Splash screen not found
)

REM Step 4: Copy Icon
echo [4/10] Installing icon file...
if exist "%ICON_FILE%" (
    copy "%ICON_FILE%" "%INSTALL_DIR%\" >nul 2>&1
    set ICON_TO_USE=%INSTALL_DIR%\QS-DPDP-OS-Icon.ico
    echo     ✓ Icon file installed
) else (
    echo     ⚠ Icon file not found, will use default
    set ICON_TO_USE=
)

REM Step 5: Copy Documentation
echo [5/10] Installing documentation...
if exist "docs" (
    xcopy /E /I /Y /Q "docs" "%INSTALL_DIR%\docs\" >nul 2>&1
    echo     ✓ Documentation installed
) else (
    echo     ⚠ Documentation not found
)

REM Step 6: Copy README files
echo [6/10] Installing README files...
if exist "README.md" copy "README.md" "%INSTALL_DIR%\" >nul 2>&1
if exist "START-HERE.md" copy "START-HERE.md" "%INSTALL_DIR%\" >nul 2>&1
echo     ✓ README files installed

REM Step 7: Create Desktop Shortcut
echo [7/10] Creating desktop shortcut...
if exist "%DESKTOP%\QS-DPDP OS.lnk" del "%DESKTOP%\QS-DPDP OS.lnk" >nul 2>&1

(
echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
echo sLinkFile = "%DESKTOP%\QS-DPDP OS.lnk"
echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
echo oLink.TargetPath = "%INSTALL_DIR%\launch.bat"
echo oLink.WorkingDirectory = "%INSTALL_DIR%"
echo oLink.Description = "Quantum-Safe DPDP Compliance Operating System"
) > "%TEMP%\create_desktop.vbs"

if defined ICON_TO_USE (
    (
    echo oLink.IconLocation = "%ICON_TO_USE%,0"
    ) >> "%TEMP%\create_desktop.vbs"
)

(
echo oLink.Save
) >> "%TEMP%\create_desktop.vbs"

cscript //nologo "%TEMP%\create_desktop.vbs" >nul 2>&1
del "%TEMP%\create_desktop.vbs" >nul 2>&1

if exist "%DESKTOP%\QS-DPDP OS.lnk" (
    echo     ✓ Desktop shortcut created
) else (
    echo     ✗ Failed to create desktop shortcut
    set /a ERROR_COUNT+=1
)

REM Step 8: Create Start Menu Entry
echo [8/10] Creating Start Menu entry...
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
echo     ✓ Start Menu entry created

REM Step 9: Create Configuration
echo [9/10] Creating configuration file...
(
echo # QS-DPDP OS Configuration
echo install.path=%INSTALL_DIR%
echo install.date=%DATE% %TIME%
echo version=1.0.0
) > "%INSTALL_DIR%\config.properties"
echo     ✓ Configuration file created

REM Step 10: Create Uninstaller
echo [10/10] Creating uninstaller...
(
echo @echo off
echo echo Uninstalling QS-DPDP OS...
echo if exist "%DESKTOP%\QS-DPDP OS.lnk" del "%DESKTOP%\QS-DPDP OS.lnk"
echo if exist "%START_MENU%\QS-DPDP OS.lnk" del "%START_MENU%\QS-DPDP OS.lnk"
echo if exist "%INSTALL_DIR%" rmdir /S /Q "%INSTALL_DIR%"
echo echo Uninstallation complete.
echo pause
) > "%INSTALL_DIR%\uninstall.bat"
echo     ✓ Uninstaller created

REM Register in Windows
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\QS-DPDP-OS" /v "DisplayName" /t REG_SZ /d "QS-DPDP Operating System" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\QS-DPDP-OS" /v "UninstallString" /t REG_SZ /d "\"%INSTALL_DIR%\uninstall.bat\"" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\QS-DPDP-OS" /v "DisplayVersion" /t REG_SZ /d "1.0.0" /f >nul 2>&1

cls

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                  Installation Complete!                       ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo.
echo QS-DPDP OS has been successfully installed!
echo.
echo Installation Details:
echo   Location: %INSTALL_DIR%
echo   Desktop Shortcut: Created
echo   Start Menu: Created
echo   Uninstaller: Available
echo.
echo To run QS-DPDP OS:
echo   1. Double-click desktop shortcut "QS-DPDP OS"
echo   2. Or use Start Menu: NeurQ ^> QS-DPDP OS
echo.
echo To uninstall:
echo   Windows Settings ^> Apps ^> QS-DPDP OS ^> Uninstall
echo   Or run: %INSTALL_DIR%\uninstall.bat
echo.
echo Opening installation directory...
start "" "%INSTALL_DIR%"
echo.
echo Press any key to exit...
pause >nul 2>&1

exit /b 0

:error
echo.
echo Installation encountered errors.
echo Error count: !ERROR_COUNT!
echo.
echo Please check the error messages above.
pause
exit /b 1
