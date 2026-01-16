@echo off
REM QS-DPDP OS Installation Script
REM Installs QS-DPDP OS on the local system

echo ========================================
echo QS-DPDP OS Installation
echo ========================================
echo.

set INSTALL_DIR=%ProgramFiles%\NeurQ\QS-DPDP-OS
set START_MENU=%ProgramData%\Microsoft\Windows\Start Menu\Programs\NeurQ

echo [1/6] Creating installation directory...
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
echo   Installed to: %INSTALL_DIR%

echo [2/6] Extracting deployment package...
if exist "deployment\QS-DPDP-OS-1.0.0-Deployment.zip" (
    powershell -Command "Expand-Archive -Path 'deployment\QS-DPDP-OS-1.0.0-Deployment.zip' -DestinationPath '%INSTALL_DIR%' -Force"
    echo   Package extracted
) else (
    echo   WARNING: Deployment package not found, copying from current directory...
    xcopy /E /I /Y "dist\executables\*" "%INSTALL_DIR%\" >nul
    xcopy /E /I /Y "docs\*" "%INSTALL_DIR%\docs\" >nul
    copy /Y "README.md" "%INSTALL_DIR%\" >nul
    copy /Y "START-HERE.md" "%INSTALL_DIR%\" >nul
)

echo [3/6] Creating Start Menu shortcuts...
if not exist "%START_MENU%" mkdir "%START_MENU%"

REM Create desktop shortcut script
(
echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
echo sLinkFile = "%START_MENU%\QS-DPDP OS.lnk"
echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
echo oLink.TargetPath = "%INSTALL_DIR%\launch.bat"
echo oLink.WorkingDirectory = "%INSTALL_DIR%"
echo oLink.Description = "Quantum-Safe DPDP Compliance Operating System"
echo oLink.Save
) > "%TEMP%\create_shortcut.vbs"
cscript //nologo "%TEMP%\create_shortcut.vbs" >nul 2>&1
del "%TEMP%\create_shortcut.vbs"

echo   Start Menu shortcut created

echo [4/6] Creating desktop shortcut...
(
echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
echo sLinkFile = "%USERPROFILE%\Desktop\QS-DPDP OS.lnk"
echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
echo oLink.TargetPath = "%INSTALL_DIR%\launch.bat"
echo oLink.WorkingDirectory = "%INSTALL_DIR%"
echo oLink.Description = "Quantum-Safe DPDP Compliance Operating System"
echo oLink.IconLocation = "shell32.dll,1"
echo oLink.Save
) > "%TEMP%\create_desktop_shortcut.vbs"
cscript //nologo "%TEMP%\create_desktop_shortcut.vbs" >nul 2>&1
del "%TEMP%\create_desktop_shortcut.vbs"

echo   Desktop shortcut created

echo [5/6] Creating configuration file...
(
echo # QS-DPDP OS Configuration
echo # Generated during installation
echo.
echo install.path=%INSTALL_DIR%
echo install.date=%DATE% %TIME%
echo java.home=%JAVA_HOME%
echo version=1.0.0
) > "%INSTALL_DIR%\config.properties"
echo   Configuration file created

echo [6/6] Creating uninstaller...
(
echo @echo off
echo REM QS-DPDP OS Uninstaller
echo echo Uninstalling QS-DPDP OS...
echo echo.
echo set INSTALL_DIR=%INSTALL_DIR%
echo set START_MENU=%START_MENU%
echo.
echo echo Removing Start Menu shortcut...
echo if exist "%START_MENU%\QS-DPDP OS.lnk" del "%START_MENU%\QS-DPDP OS.lnk"
echo.
echo echo Removing desktop shortcut...
echo if exist "%USERPROFILE%\Desktop\QS-DPDP OS.lnk" del "%USERPROFILE%\Desktop\QS-DPDP OS.lnk"
echo.
echo echo Removing installation directory...
echo if exist "%INSTALL_DIR%" rmdir /S /Q "%INSTALL_DIR%"
echo.
echo echo QS-DPDP OS has been uninstalled.
echo pause
) > "%INSTALL_DIR%\uninstall.bat"
echo   Uninstaller created

echo.
echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo Installation Location: %INSTALL_DIR%
echo.
echo Shortcuts created:
echo   - Start Menu: %START_MENU%\QS-DPDP OS.lnk
echo   - Desktop: %USERPROFILE%\Desktop\QS-DPDP OS.lnk
echo.
echo To run QS-DPDP OS:
echo   1. Double-click desktop shortcut
echo   2. Or use Start Menu: NeurQ ^> QS-DPDP OS
echo   3. Or run: %INSTALL_DIR%\launch.bat
echo.
echo To uninstall:
echo   Run: %INSTALL_DIR%\uninstall.bat
echo.
pause
