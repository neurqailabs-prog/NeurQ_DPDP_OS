@echo off
REM ========================================
REM QS-DPDP OS - Windows Setup Installer
REM ========================================
REM Proper Windows-style installer
REM Run this file to install QS-DPDP OS

setlocal enabledelayedexpansion

:: Configuration
set "PRODUCT_NAME=QS-DPDP OS"
set "VERSION=1.0.0"
set "INSTALL_DIR=%LOCALAPPDATA%\NeurQ\QS-DPDP-OS"
set "DESKTOP=%USERPROFILE%\Desktop"
set "START_MENU=%APPDATA%\Microsoft\Windows\Start Menu\Programs\NeurQ"

:: Clear screen
cls

:: Header
echo.
echo ========================================
echo   %PRODUCT_NAME% %VERSION% - Setup
echo ========================================
echo.
echo This will install %PRODUCT_NAME% on your computer.
echo.
echo Installation location: %INSTALL_DIR%
echo.
echo Press any key to begin installation, or Ctrl+C to cancel...
pause >nul

:: Start installation
echo.
echo ========================================
echo Installing %PRODUCT_NAME%
echo ========================================
echo.

:: Step 1: Create directory
echo [Step 1/10] Creating installation directory...
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%" 2>nul
    if errorlevel 1 (
        echo   ERROR: Cannot create directory
        echo   Please check permissions or choose different location
        pause
        exit /b 1
    )
    echo   ✅ Created: %INSTALL_DIR%
) else (
    echo   ✅ Directory exists
)

:: Step 2: Copy application files and create desktop launcher
echo.
echo [Step 2/10] Installing application files...
if exist "qs-dpdp-core\target\qs-dpdp-core-1.0.0.jar" (
    if not exist "%INSTALL_DIR%\core" mkdir "%INSTALL_DIR%\core" >nul 2>&1
    copy "qs-dpdp-core\target\qs-dpdp-core-1.0.0.jar" "%INSTALL_DIR%\core\" >nul 2>&1
    echo   ✅ QS-DPDP Core JAR installed
) else (
    echo   ⚠️  QS-DPDP Core JAR not found - will create launcher
)

:: Create desktop application launcher (JavaFX, NOT browser)
(
echo @echo off
echo REM QS-DPDP OS - Desktop Application Launcher
echo REM Launches JavaFX desktop application (NOT browser)
echo setlocal
echo.
echo set INSTALL_DIR=%%~dp0
echo set JAVA_HOME=%%JAVA_HOME%%
echo.
echo REM Check for Java
echo where java ^>nul 2^>^&1
echo if %%ERRORLEVEL%% NEQ 0 ^(
echo     echo ERROR: Java 21+ required!
echo     echo Please install Java from https://adoptium.net/
echo     pause
echo     exit /b 1
echo ^)
echo.
echo REM Show splash screen (HTML preview, then launch desktop app)
echo if exist "%%INSTALL_DIR%%splash-screen.html" ^(
echo     start "" "%%INSTALL_DIR%%splash-screen.html"
echo     timeout /t 2 /nobreak ^>nul
echo ^)
echo.
echo REM Launch JavaFX Desktop Application
echo if exist "%%INSTALL_DIR%%core\qs-dpdp-core-1.0.0.jar" ^(
echo     java --module-path "%%INSTALL_DIR%%\lib" --add-modules javafx.controls,javafx.fxml,javafx.web -jar "%%INSTALL_DIR%%core\qs-dpdp-core-1.0.0.jar"
echo ^) else if exist "%%INSTALL_DIR%%qs-dpdp-core-1.0.0.jar" ^(
echo     java --module-path "%%INSTALL_DIR%%\lib" --add-modules javafx.controls,javafx.fxml,javafx.web -jar "%%INSTALL_DIR%%qs-dpdp-core-1.0.0.jar"
echo ^) else if exist "%%INSTALL_DIR%%qs-dpdp-core.exe" ^(
echo     start "" "%%INSTALL_DIR%%qs-dpdp-core.exe"
echo ^) else ^(
echo     echo.
echo     echo Application JAR not found. Please build the project first.
echo     echo.
echo     echo To build:
echo     echo   1. Install Maven 3.8+
echo     echo   2. Run: build-all.bat
echo     echo   3. Run: create-executables.bat
echo     echo   4. Run this installer again
echo     echo.
echo     pause
echo ^)
echo.
echo endlocal
) > "%INSTALL_DIR%\launch.bat"
echo   ✅ Desktop application launcher created

:: Step 3: Copy splash screen
echo.
echo [Step 3/10] Installing splash screen...
if exist "splash-screen.html" (
    copy "splash-screen.html" "%INSTALL_DIR%\" >nul 2>&1
    echo   ✅ Splash screen installed
) else (
    echo   ⚠️  Splash screen not found
)

:: Step 4: Copy icon
echo.
echo [Step 4/10] Installing icon...
if exist "QS-DPDP-OS-Icon.ico" (
    copy "QS-DPDP-OS-Icon.ico" "%INSTALL_DIR%\" >nul 2>&1
    set "ICON_PATH=%INSTALL_DIR%\QS-DPDP-OS-Icon.ico"
    echo   ✅ Icon installed
) else (
    echo   ⚠️  Icon file not found
    set "ICON_PATH="
)

:: Step 5: Copy documentation
echo.
echo [Step 5/10] Installing documentation...
if exist "docs" (
    if not exist "%INSTALL_DIR%\docs" mkdir "%INSTALL_DIR%\docs" >nul 2>&1
    xcopy /E /I /Y "docs\*" "%INSTALL_DIR%\docs\" >nul 2>&1
    echo   ✅ Documentation installed
) else (
    echo   ⚠️  Documentation not found
)

if exist "README.md" copy "README.md" "%INSTALL_DIR%\" >nul 2>&1
if exist "START-HERE.md" copy "START-HERE.md" "%INSTALL_DIR%\" >nul 2>&1

:: Step 6: Create desktop shortcut
echo.
echo [Step 6/10] Creating desktop shortcut...
call :create_shortcut "%DESKTOP%\%PRODUCT_NAME%.lnk" "%INSTALL_DIR%\launch.bat" "%ICON_PATH%"
if errorlevel 1 (
    echo   ⚠️  Desktop shortcut creation had issues
) else (
    echo   ✅ Desktop shortcut created
)

:: Step 7: Create Start Menu shortcut
echo.
echo [Step 7/10] Creating Start Menu entry...
if not exist "%START_MENU%" mkdir "%START_MENU%" >nul 2>&1
call :create_shortcut "%START_MENU%\%PRODUCT_NAME%.lnk" "%INSTALL_DIR%\launch.bat" "%ICON_PATH%"
if errorlevel 1 (
    echo   ⚠️  Start Menu shortcut creation had issues
) else (
    echo   ✅ Start Menu entry created
)

:: Step 8: Create configuration
echo.
echo [Step 8/10] Creating configuration...
(
echo # QS-DPDP OS Configuration
echo install.path=%INSTALL_DIR%
echo install.date=%DATE% %TIME%
echo version=%VERSION%
) > "%INSTALL_DIR%\config.properties"
echo   ✅ Configuration created

:: Step 9: Create uninstaller
echo.
echo [Step 9/10] Creating uninstaller...
(
echo @echo off
echo echo Uninstalling %PRODUCT_NAME%...
echo.
echo if exist "%DESKTOP%\%PRODUCT_NAME%.lnk" del "%DESKTOP%\%PRODUCT_NAME%.lnk"
echo if exist "%START_MENU%\%PRODUCT_NAME%.lnk" del "%START_MENU%\%PRODUCT_NAME%.lnk"
echo if exist "%INSTALL_DIR%" rmdir /S /Q "%INSTALL_DIR%"
echo echo %PRODUCT_NAME% has been uninstalled.
echo pause
) > "%INSTALL_DIR%\uninstall.bat"
echo   ✅ Uninstaller created

:: Step 10: Register in Windows
echo.
echo [Step 10/10] Registering application...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\%PRODUCT_NAME%" /v "DisplayName" /t REG_SZ /d "%PRODUCT_NAME%" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\%PRODUCT_NAME%" /v "UninstallString" /t REG_SZ /d "%INSTALL_DIR%\uninstall.bat" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\%PRODUCT_NAME%" /v "DisplayVersion" /t REG_SZ /d "%VERSION%" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\%PRODUCT_NAME%" /v "Publisher" /t REG_SZ /d "NeurQ Technologies" /f >nul 2>&1
echo   ✅ Application registered

:: Refresh desktop
echo.
echo Refreshing desktop...
taskkill /F /IM explorer.exe >nul 2>&1
timeout /t 1 /nobreak >nul
start explorer.exe
timeout /t 2 /nobreak >nul

:: Completion
cls
echo.
echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo %PRODUCT_NAME% has been successfully installed!
echo.
echo Installation Details:
echo   Location: %INSTALL_DIR%
echo   Desktop Shortcut: %DESKTOP%\%PRODUCT_NAME%.lnk
echo   Start Menu: %START_MENU%\%PRODUCT_NAME%.lnk
echo.
echo To run %PRODUCT_NAME%:
echo   - Double-click desktop shortcut
echo   - Or use Start Menu: NeurQ ^> %PRODUCT_NAME%
echo.
echo To uninstall:
echo   - Run: %INSTALL_DIR%\uninstall.bat
echo   - Or: Control Panel ^> Programs ^> Uninstall
echo.
echo Opening installation directory...
start "" "%INSTALL_DIR%"
echo.
pause
exit /b 0

:: Function to create shortcut
:create_shortcut
set SHORTCUT=%~1
set TARGET=%~2
set ICON=%~3

(
echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
echo sLinkFile = "%SHORTCUT%"
echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
echo oLink.TargetPath = "%TARGET%"
echo oLink.WorkingDirectory = "%~dp2"
echo oLink.Description = "%PRODUCT_NAME%"
) > "%TEMP%\sc.vbs"

if defined ICON (
    if exist "%ICON%" (
        (
        echo oLink.IconLocation = "%ICON%,0"
        ) >> "%TEMP%\sc.vbs"
    )
)

(
echo oLink.Save
) >> "%TEMP%\sc.vbs"

cscript //nologo "%TEMP%\sc.vbs" >nul 2>&1
set ERR=%ERRORLEVEL%
del "%TEMP%\sc.vbs" >nul 2>&1
exit /b %ERR%
