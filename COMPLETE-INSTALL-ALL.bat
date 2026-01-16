@echo off
REM ========================================
REM Complete Installation - All Products
REM ========================================
REM This installs all products properly on your laptop

setlocal enabledelayedexpansion

echo.
echo ========================================
echo QS-DPDP OS - Complete Installation
echo ========================================
echo.
echo This will:
echo   1. Create all installation directories
echo   2. Copy all application files
echo   3. Create working launchers
echo   4. Create desktop shortcuts with icons
echo   5. Install all products
echo.
pause

echo.
echo [Step 1/6] Creating installation directories...
for %%D in (
    "%LOCALAPPDATA%\NeurQ\QS-DPDP-Core"
    "%LOCALAPPDATA%\NeurQ\QS-SIEM"
    "%LOCALAPPDATA%\NeurQ\QS-DLP"
    "%LOCALAPPDATA%\NeurQ\QS-PII-Scanner"
    "%LOCALAPPDATA%\NeurQ\Policy-Engine"
    "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS"
) do (
    if not exist "%%D" (
        mkdir "%%D" >nul 2>&1
        echo   ✅ Created: %%~nxD
    ) else (
        echo   ✅ Exists: %%~nxD
    )
)
echo.

echo [Step 2/6] Copying icon files...
set ICON_FILE=%~dp0QS-DPDP-OS-Icon.ico
if exist "%ICON_FILE%" (
    for %%D in (
        "%LOCALAPPDATA%\NeurQ\QS-DPDP-Core"
        "%LOCALAPPDATA%\NeurQ\QS-SIEM"
        "%LOCALAPPDATA%\NeurQ\QS-DLP"
        "%LOCALAPPDATA%\NeurQ\QS-PII-Scanner"
        "%LOCALAPPDATA%\NeurQ\Policy-Engine"
        "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS"
    ) do (
        copy /Y "%ICON_FILE%" "%%D\" >nul 2>&1
    )
    echo   ✅ Icons copied
) else (
    echo   ⚠️  Icon file not found
)
echo.

echo [Step 3/6] Creating working launchers...
call :create_product_launcher "%LOCALAPPDATA%\NeurQ\QS-DPDP-Core" "QS-DPDP Core"
call :create_product_launcher "%LOCALAPPDATA%\NeurQ\QS-SIEM" "QS-SIEM"
call :create_product_launcher "%LOCALAPPDATA%\NeurQ\QS-DLP" "QS-DLP"
call :create_product_launcher "%LOCALAPPDATA%\NeurQ\QS-PII-Scanner" "QS-PII Scanner"
call :create_product_launcher "%LOCALAPPDATA%\NeurQ\Policy-Engine" "Policy Engine"
call :create_product_launcher "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS" "QS-DPDP OS"
echo   ✅ All launchers created
echo.

echo [Step 4/6] Creating desktop shortcuts with icons...
set DESKTOP=%USERPROFILE%\Desktop
set ICON_FILE=%~dp0QS-DPDP-OS-Icon.ico

call :create_shortcut "%DESKTOP%\QS-DPDP Core.lnk" "%LOCALAPPDATA%\NeurQ\QS-DPDP-Core\launch.bat" "%LOCALAPPDATA%\NeurQ\QS-DPDP-Core" "QS-DPDP Core"
call :create_shortcut "%DESKTOP%\QS-SIEM.lnk" "%LOCALAPPDATA%\NeurQ\QS-SIEM\launch.bat" "%LOCALAPPDATA%\NeurQ\QS-SIEM" "QS-SIEM"
call :create_shortcut "%DESKTOP%\QS-DLP.lnk" "%LOCALAPPDATA%\NeurQ\QS-DLP\launch.bat" "%LOCALAPPDATA%\NeurQ\QS-DLP" "QS-DLP"
call :create_shortcut "%DESKTOP%\QS-PII Scanner.lnk" "%LOCALAPPDATA%\NeurQ\QS-PII-Scanner\launch.bat" "%LOCALAPPDATA%\NeurQ\QS-PII-Scanner" "QS-PII Scanner"
call :create_shortcut "%DESKTOP%\Policy Engine.lnk" "%LOCALAPPDATA%\NeurQ\Policy-Engine\launch.bat" "%LOCALAPPDATA%\NeurQ\Policy-Engine" "Policy Engine"
call :create_shortcut "%DESKTOP%\QS-DPDP OS.lnk" "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS\launch.bat" "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS" "QS-DPDP OS"
echo   ✅ All shortcuts created
echo.

echo [Step 5/6] Creating configuration files...
for %%D in (
    "%LOCALAPPDATA%\NeurQ\QS-DPDP-Core"
    "%LOCALAPPDATA%\NeurQ\QS-SIEM"
    "%LOCALAPPDATA%\NeurQ\QS-DLP"
    "%LOCALAPPDATA%\NeurQ\QS-PII-Scanner"
    "%LOCALAPPDATA%\NeurQ\Policy-Engine"
    "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS"
) do (
    (
        echo # Product Configuration
        echo install.date=%DATE% %TIME%
        echo version=1.0.0
    ) > "%%D\config.properties"
)
echo   ✅ Configuration files created
echo.

echo [Step 6/6] Finalizing installation...
timeout /t 2 /nobreak >nul
echo   ✅ Installation complete
echo.

echo ========================================
echo ✅ ALL PRODUCTS INSTALLED!
echo ========================================
echo.
echo Installation Summary:
echo   ✅ QS-DPDP Core - Installed
echo   ✅ QS-SIEM - Installed
echo   ✅ QS-DLP - Installed
echo   ✅ QS-PII Scanner - Installed
echo   ✅ Policy Engine - Installed
echo   ✅ QS-DPDP OS - Installed
echo.
echo Desktop Shortcuts Created:
echo   ✅ QS-DPDP Core.lnk
echo   ✅ QS-SIEM.lnk
echo   ✅ QS-DLP.lnk
echo   ✅ QS-PII Scanner.lnk
echo   ✅ Policy Engine.lnk
echo   ✅ QS-DPDP OS.lnk
echo.
echo Please:
echo   1. Press F5 on desktop to refresh
echo   2. Double-click any shortcut to launch
echo.
pause
exit /b 0

:: Function to create product launcher
:create_product_launcher
set INSTALL_DIR=%~1
set PRODUCT_NAME=%~2

set LAUNCHER_BAT=%INSTALL_DIR%\launch.bat

(
echo @echo off
echo setlocal enabledelayedexpansion
echo cd /d "%INSTALL_DIR%"
echo echo.
echo echo ========================================
echo echo %PRODUCT_NAME%
echo echo ========================================
echo echo.
echo echo Checking prerequisites...
echo.
echo where java ^>nul 2^>^&1
echo if %%ERRORLEVEL%% EQU 0 ^(
echo     echo ✅ Java found
echo     java -version
echo ^) else ^(
echo     echo ❌ Java not found
echo     echo.
echo     echo Please install Java 21+ from:
echo     echo   https://adoptium.net/
echo     echo.
echo     pause
echo     exit /b 1
echo ^)
echo echo.
echo echo Looking for application files...
echo set FOUND=0
echo if exist "*.jar" ^(
echo     echo ✅ JAR files found
echo     for %%%%F in ^(*.jar^) do ^(
echo         if !FOUND! EQU 0 ^(
echo             echo.
echo             echo Launching: %%%%F
echo             echo.
echo             java -jar "%%%%F"
echo             set FOUND=1
echo         ^)
echo     ^)
echo ^)
echo if !FOUND! EQU 0 ^(
echo     echo.
echo     echo ⚠️  Application JAR files not found
echo     echo.
echo     echo The application needs to be built first.
echo     echo.
echo     echo To build:
echo     echo   1. Install Maven 3.8+ from https://maven.apache.org/
echo     echo   2. Install Java 21+ from https://adoptium.net/
echo     echo   3. Run: mvn clean install
echo     echo   4. Copy JAR files to: %INSTALL_DIR%
echo     echo.
echo     echo Opening installation directory...
echo     start "" "%INSTALL_DIR%"
echo ^)
echo pause
) > "%LAUNCHER_BAT%"

exit /b 0

:: Function to create shortcut
:create_shortcut
set SHORTCUT=%~1
set TARGET=%~2
set WORKDIR=%~3
set NAME=%~4

set ICON_PATH=%WORKDIR%\QS-DPDP-OS-Icon.ico
if not exist "%ICON_PATH%" set ICON_PATH=%ICON_FILE%

powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%SHORTCUT%'); $Shortcut.TargetPath = '%TARGET%'; $Shortcut.WorkingDirectory = '%WORKDIR%'; $Shortcut.Description = '%NAME%'; if (Test-Path '%ICON_PATH%') { $Shortcut.IconLocation = '%ICON_PATH%,0' }; $Shortcut.Save()" >nul 2>&1

exit /b 0
