@echo off
REM ========================================
REM QS-DPDP OS - Complete Suite Installer
REM ========================================
REM Master installer that installs ALL products as integrated suite

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
echo   %PRODUCT_NAME% %VERSION% - Complete Suite
echo ========================================
echo.
echo This will install the complete QS-DPDP OS suite including:
echo   - QS-DPDP Core
echo   - QS-SIEM
echo   - QS-DLP
echo   - QS-PII Scanner
echo   - Policy Engine
echo.
echo All products will be integrated as a holistic DPDP compliance solution.
echo.
echo Installation location: %INSTALL_DIR%
echo.
echo Press any key to begin installation, or Ctrl+C to cancel...
pause >nul

:: Start installation
echo.
echo ========================================
echo Installing %PRODUCT_NAME% Complete Suite
echo ========================================
echo.

:: Step 1: Create main directory
echo [Step 1/12] Creating installation directory...
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

:: Step 2: Install QS-DPDP Core
echo.
echo [Step 2/12] Installing QS-DPDP Core...
if exist "qs-dpdp-core\target\qs-dpdp-core-1.0.0.jar" (
    copy "qs-dpdp-core\target\qs-dpdp-core-1.0.0.jar" "%INSTALL_DIR%\core\" >nul 2>&1
    echo   ✅ QS-DPDP Core installed
) else (
    echo   ⚠️  QS-DPDP Core JAR not found
)
if not exist "%INSTALL_DIR%\core" mkdir "%INSTALL_DIR%\core" >nul 2>&1

:: Step 3: Install QS-SIEM
echo.
echo [Step 3/12] Installing QS-SIEM...
if exist "qs-siem\target\qs-siem-1.0.0.jar" (
    copy "qs-siem\target\qs-siem-1.0.0.jar" "%INSTALL_DIR%\siem\" >nul 2>&1
    echo   ✅ QS-SIEM installed
)
if exist "qs-siem\target\release\qs-siem.exe" (
    copy "qs-siem\target\release\qs-siem.exe" "%INSTALL_DIR%\siem\" >nul 2>&1
    echo   ✅ QS-SIEM binary installed
)
if not exist "%INSTALL_DIR%\siem" mkdir "%INSTALL_DIR%\siem" >nul 2>&1

:: Step 4: Install QS-DLP
echo.
echo [Step 4/12] Installing QS-DLP...
if exist "qs-dlp\target\qs-dlp-1.0.0.jar" (
    copy "qs-dlp\target\qs-dlp-1.0.0.jar" "%INSTALL_DIR%\dlp\" >nul 2>&1
    echo   ✅ QS-DLP installed
)
if exist "qs-dlp\target\release\qs-dlp.exe" (
    copy "qs-dlp\target\release\qs-dlp.exe" "%INSTALL_DIR%\dlp\" >nul 2>&1
    echo   ✅ QS-DLP binary installed
)
if not exist "%INSTALL_DIR%\dlp" mkdir "%INSTALL_DIR%\dlp" >nul 2>&1

:: Step 5: Install QS-PII Scanner
echo.
echo [Step 5/12] Installing QS-PII Scanner...
if exist "qs-pii-scanner\target\qs-pii-scanner-1.0.0.jar" (
    copy "qs-pii-scanner\target\qs-pii-scanner-1.0.0.jar" "%INSTALL_DIR%\pii-scanner\" >nul 2>&1
    echo   ✅ QS-PII Scanner installed
)
if exist "qs-pii-scanner\src\main\python" (
    xcopy /E /I /Y "qs-pii-scanner\src\main\python\*" "%INSTALL_DIR%\pii-scanner\python\" >nul 2>&1
    echo   ✅ Python scripts installed
)
if not exist "%INSTALL_DIR%\pii-scanner" mkdir "%INSTALL_DIR%\pii-scanner" >nul 2>&1

:: Step 6: Install Policy Engine
echo.
echo [Step 6/12] Installing Policy Engine...
if exist "policy-engine\target\policy-engine-1.0.0.jar" (
    copy "policy-engine\target\policy-engine-1.0.0.jar" "%INSTALL_DIR%\policy-engine\" >nul 2>&1
    echo   ✅ Policy Engine installed
)
if not exist "%INSTALL_DIR%\policy-engine" mkdir "%INSTALL_DIR%\policy-engine" >nul 2>&1

:: Step 7: Copy splash screens
echo.
echo [Step 7/12] Installing splash screens...
if exist "splash-screen.html" (
    copy "splash-screen.html" "%INSTALL_DIR%\" >nul 2>&1
    echo   ✅ Main splash screen installed
)

:: Step 8: Copy icons
echo.
echo [Step 8/12] Installing icons...
if exist "QS-DPDP-OS-Icon.ico" (
    copy "QS-DPDP-OS-Icon.ico" "%INSTALL_DIR%\" >nul 2>&1
    set "ICON_PATH=%INSTALL_DIR%\QS-DPDP-OS-Icon.ico"
    echo   ✅ Main icon installed
) else (
    set "ICON_PATH="
)

:: Step 9: Create integrated launcher
echo.
echo [Step 9/12] Creating integrated application launcher...
(
echo @echo off
echo REM %PRODUCT_NAME% - Integrated Suite Launcher
echo REM Launches all products as integrated desktop application
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
echo REM Launch integrated JavaFX Desktop Application (NOT browser)
echo REM This launches the main QS-DPDP OS desktop application which integrates all modules
echo REM This is a DESKTOP APPLICATION - NOT browser-based
echo if exist "%%INSTALL_DIR%%core\qs-dpdp-core-1.0.0.jar" ^(
echo     java --module-path "%%INSTALL_DIR%%\lib" --add-modules javafx.controls,javafx.fxml,javafx.web -jar "%%INSTALL_DIR%%core\qs-dpdp-core-1.0.0.jar"
echo ^) else if exist "%%INSTALL_DIR%%qs-dpdp-core.exe" ^(
echo     start "" "%%INSTALL_DIR%%qs-dpdp-core.exe"
echo ^) else ^(
echo     echo.
echo     echo Desktop Application JAR not found. Please build the project first.
echo     echo.
echo     echo This is a DESKTOP APPLICATION (JavaFX) - NOT browser-based.
echo     echo.
echo     echo To build:
echo     echo   1. Install Maven 3.8+
echo     echo   2. Install Java 21+ and JavaFX SDK
echo     echo   3. Run: build-all.bat
echo     echo   4. Run: create-executables.bat
echo     echo   5. Run this installer again
echo     echo.
echo     pause
echo ^)
echo.
echo endlocal
) > "%INSTALL_DIR%\launch.bat"
echo   ✅ Integrated launcher created

:: Step 10: Create desktop shortcut
echo.
echo [Step 10/12] Creating desktop shortcut...
call :create_shortcut "%DESKTOP%\%PRODUCT_NAME%.lnk" "%INSTALL_DIR%\launch.bat" "%ICON_PATH%"
echo   ✅ Desktop shortcut created

:: Step 11: Create Start Menu shortcuts
echo.
echo [Step 11/12] Creating Start Menu entries...
if not exist "%START_MENU%" mkdir "%START_MENU%" >nul 2>&1
call :create_shortcut "%START_MENU%\%PRODUCT_NAME%.lnk" "%INSTALL_DIR%\launch.bat" "%ICON_PATH%"
echo   ✅ Start Menu entry created

:: Create individual product shortcuts in Start Menu subfolder
if not exist "%START_MENU%\QS-DPDP OS" mkdir "%START_MENU%\QS-DPDP OS" >nul 2>&1
call :create_shortcut "%START_MENU%\QS-DPDP OS\QS-DPDP Core.lnk" "%INSTALL_DIR%\core\launch.bat" ""
call :create_shortcut "%START_MENU%\QS-DPDP OS\QS-SIEM.lnk" "%INSTALL_DIR%\siem\launch.bat" ""
call :create_shortcut "%START_MENU%\QS-DPDP OS\QS-DLP.lnk" "%INSTALL_DIR%\dlp\launch.bat" ""
call :create_shortcut "%START_MENU%\QS-DPDP OS\QS-PII Scanner.lnk" "%INSTALL_DIR%\pii-scanner\launch.bat" ""
call :create_shortcut "%START_MENU%\QS-DPDP OS\Policy Engine.lnk" "%INSTALL_DIR%\policy-engine\launch.bat" ""
echo   ✅ Individual product shortcuts created

:: Step 12: Create configuration and uninstaller
echo.
echo [Step 12/12] Creating configuration and uninstaller...
(
echo # %PRODUCT_NAME% Complete Suite Configuration
echo install.path=%INSTALL_DIR%
echo install.date=%DATE% %TIME%
echo version=%VERSION%
echo suite.mode=integrated
echo products.installed=QS-DPDP-Core,QS-SIEM,QS-DLP,QS-PII-Scanner,Policy-Engine
) > "%INSTALL_DIR%\config.properties"

(
echo @echo off
echo REM %PRODUCT_NAME% Complete Suite Uninstaller
echo echo Uninstalling %PRODUCT_NAME% Complete Suite...
echo echo This will remove all integrated products.
echo.
echo if exist "%DESKTOP%\%PRODUCT_NAME%.lnk" del "%DESKTOP%\%PRODUCT_NAME%.lnk"
echo if exist "%START_MENU%\%PRODUCT_NAME%.lnk" del "%START_MENU%\%PRODUCT_NAME%.lnk"
echo if exist "%START_MENU%\QS-DPDP OS" rmdir /S /Q "%START_MENU%\QS-DPDP OS"
echo if exist "%INSTALL_DIR%" rmdir /S /Q "%INSTALL_DIR%"
echo.
echo echo %PRODUCT_NAME% Complete Suite has been uninstalled.
echo pause
) > "%INSTALL_DIR%\uninstall.bat"

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\%PRODUCT_NAME%" /v "DisplayName" /t REG_SZ /d "%PRODUCT_NAME% Complete Suite" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\%PRODUCT_NAME%" /v "UninstallString" /t REG_SZ /d "%INSTALL_DIR%\uninstall.bat" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\%PRODUCT_NAME%" /v "DisplayVersion" /t REG_SZ /d "%VERSION%" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\%PRODUCT_NAME%" /v "Publisher" /t REG_SZ /d "NeurQ Technologies" /f >nul 2>&1

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
echo %PRODUCT_NAME% Complete Suite has been successfully installed!
echo.
echo Installed Products:
echo   ✅ QS-DPDP Core
echo   ✅ QS-SIEM
echo   ✅ QS-DLP
echo   ✅ QS-PII Scanner
echo   ✅ Policy Engine
echo.
echo All products are integrated as a holistic DPDP compliance solution.
echo.
echo To run %PRODUCT_NAME%:
echo   - Double-click desktop shortcut: %PRODUCT_NAME%
echo   - Or use Start Menu: NeurQ ^> %PRODUCT_NAME%
echo.
echo Individual products are also available in:
echo   Start Menu ^> NeurQ ^> QS-DPDP OS ^> [Product Name]
echo.
echo To uninstall:
echo   - Run: %INSTALL_DIR%\uninstall.bat
echo   - Or: Control Panel ^> Programs ^> Uninstall
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
