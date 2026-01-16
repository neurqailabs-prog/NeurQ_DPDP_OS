@echo off
REM ========================================
REM QS-DPDP Core - Windows Setup Installer
REM ========================================
REM Individual installer for QS-DPDP Core

setlocal enabledelayedexpansion

:: Configuration
set "PRODUCT_NAME=QS-DPDP Core"
set "PRODUCT_SHORT=QS-DPDP-Core"
set "VERSION=1.0.0"
set "INSTALL_DIR=%LOCALAPPDATA%\NeurQ\QS-DPDP-Core"
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
echo [Step 1/8] Creating installation directory...
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%" 2>nul
    if errorlevel 1 (
        echo   ERROR: Cannot create directory
        pause
        exit /b 1
    )
    echo   ✅ Created: %INSTALL_DIR%
) else (
    echo   ✅ Directory exists
)

:: Step 2: Copy application files
echo.
echo [Step 2/8] Installing application files...
if exist "qs-dpdp-core\target\qs-dpdp-core-1.0.0.jar" (
    copy "qs-dpdp-core\target\qs-dpdp-core-1.0.0.jar" "%INSTALL_DIR%\" >nul 2>&1
    echo   ✅ Application JAR installed
) else (
    echo   ⚠️  JAR file not found - will create launcher
)

:: Step 3: Copy splash screen
echo.
echo [Step 3/8] Installing splash screen...
if exist "splash-screens\qs-dpdp-core-splash.html" (
    copy "splash-screens\qs-dpdp-core-splash.html" "%INSTALL_DIR%\splash-screen.html" >nul 2>&1
    echo   ✅ Splash screen installed
) else (
    echo   ⚠️  Splash screen not found
)

:: Step 4: Copy icon
echo.
echo [Step 4/8] Installing icon...
if exist "icons\qs-dpdp-core-icon.ico" (
    copy "icons\qs-dpdp-core-icon.ico" "%INSTALL_DIR%\%PRODUCT_SHORT%-Icon.ico" >nul 2>&1
    set "ICON_PATH=%INSTALL_DIR%\%PRODUCT_SHORT%-Icon.ico"
    echo   ✅ Icon installed
) else (
    echo   ⚠️  Icon file not found
    set "ICON_PATH="
)

:: Step 5: Create launcher
echo.
echo [Step 5/8] Creating application launcher...
(
echo @echo off
echo REM %PRODUCT_NAME% Launcher
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
echo REM Show splash screen
echo if exist "%%INSTALL_DIR%%splash-screen.html" ^(
echo     start "" "%%INSTALL_DIR%%splash-screen.html"
echo     timeout /t 2 /nobreak ^>nul
echo ^)
echo.
echo REM Launch JavaFX desktop application
echo if exist "%%INSTALL_DIR%%qs-dpdp-core-1.0.0.jar" ^(
echo     java --module-path "%%INSTALL_DIR%%\lib" --add-modules javafx.controls,javafx.fxml,javafx.web -jar "%%INSTALL_DIR%%qs-dpdp-core-1.0.0.jar"
echo ^) else if exist "%%INSTALL_DIR%%qs-dpdp-core.exe" ^(
echo     start "" "%%INSTALL_DIR%%qs-dpdp-core.exe"
echo ^) else ^(
echo     echo Application not found. Please build the project first.
echo     echo.
echo     echo To build:
echo     echo   1. Install Maven 3.8+
echo     echo   2. Run: build-all.bat
echo     echo   3. Run: create-executables.bat
echo     pause
echo ^)
echo.
echo endlocal
) > "%INSTALL_DIR%\launch.bat"
echo   ✅ Launcher created

:: Step 6: Create desktop shortcut
echo.
echo [Step 6/8] Creating desktop shortcut...
call :create_shortcut "%DESKTOP%\%PRODUCT_NAME%.lnk" "%INSTALL_DIR%\launch.bat" "%ICON_PATH%"
if errorlevel 1 (
    echo   ⚠️  Desktop shortcut creation had issues
) else (
    echo   ✅ Desktop shortcut created
)

:: Step 7: Create Start Menu shortcut
echo.
echo [Step 7/8] Creating Start Menu entry...
if not exist "%START_MENU%" mkdir "%START_MENU%" >nul 2>&1
call :create_shortcut "%START_MENU%\%PRODUCT_NAME%.lnk" "%INSTALL_DIR%\launch.bat" "%ICON_PATH%"
if errorlevel 1 (
    echo   ⚠️  Start Menu shortcut creation had issues
) else (
    echo   ✅ Start Menu entry created
)

:: Step 8: Create configuration and uninstaller
echo.
echo [Step 8/8] Creating configuration and uninstaller...
(
echo # %PRODUCT_NAME% Configuration
echo install.path=%INSTALL_DIR%
echo install.date=%DATE% %TIME%
echo version=%VERSION%
) > "%INSTALL_DIR%\config.properties"

(
echo @echo off
echo echo Uninstalling %PRODUCT_NAME%...
echo if exist "%DESKTOP%\%PRODUCT_NAME%.lnk" del "%DESKTOP%\%PRODUCT_NAME%.lnk"
echo if exist "%START_MENU%\%PRODUCT_NAME%.lnk" del "%START_MENU%\%PRODUCT_NAME%.lnk"
echo if exist "%INSTALL_DIR%" rmdir /S /Q "%INSTALL_DIR%"
echo echo %PRODUCT_NAME% has been uninstalled.
echo pause
) > "%INSTALL_DIR%\uninstall.bat"

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\%PRODUCT_NAME%" /v "DisplayName" /t REG_SZ /d "%PRODUCT_NAME%" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\%PRODUCT_NAME%" /v "UninstallString" /t REG_SZ /d "%INSTALL_DIR%\uninstall.bat" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\%PRODUCT_NAME%" /v "DisplayVersion" /t REG_SZ /d "%VERSION%" /f >nul 2>&1

echo   ✅ Configuration and uninstaller created

:: Refresh desktop
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
echo To run %PRODUCT_NAME%:
echo   - Double-click desktop shortcut
echo   - Or use Start Menu: NeurQ ^> %PRODUCT_NAME%
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
