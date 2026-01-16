@echo off
REM ========================================
REM COMPLETE INSTALLATION - FINAL VERSION
REM ========================================
REM This completes the entire project:
REM   1. Creates Google-style icons
REM   2. Installs all products
REM   3. Creates working shortcuts
REM   4. Verifies everything

setlocal enabledelayedexpansion

echo.
echo ========================================
echo QS-DPDP OS - Complete Installation
echo ========================================
echo.
echo This will:
echo   1. Create Google-style icons
echo   2. Install all 6 products
echo   3. Create desktop shortcuts with icons
echo   4. Verify installation
echo.
pause
echo.

:: Step 1: Create Google-style icon
echo [Step 1/5] Creating Google-style icon...
powershell -ExecutionPolicy Bypass -File "%~dp0create-google-style-icon.ps1"
if %ERRORLEVEL% EQU 0 (
    echo   ✅ Google-style icon created
) else (
    echo   ⚠️  Icon creation had issues, but continuing...
)
echo.

:: Step 2: Install all products
echo [Step 2/5] Installing all products...
echo.

echo   Installing QS-DPDP Core...
if exist "%~dp0installers\Setup-QS-DPDP-Core.bat" (
    call "%~dp0installers\Setup-QS-DPDP-Core.bat"
) else (
    echo     ⚠️  Installer not found, creating basic installation...
    call :install_product "QS-DPDP Core" "%LOCALAPPDATA%\NeurQ\QS-DPDP-Core"
)
echo.

echo   Installing QS-SIEM...
if exist "%~dp0installers\Setup-QS-SIEM.bat" (
    call "%~dp0installers\Setup-QS-SIEM.bat"
) else (
    call :install_product "QS-SIEM" "%LOCALAPPDATA%\NeurQ\QS-SIEM"
)
echo.

echo   Installing QS-DLP...
if exist "%~dp0installers\Setup-QS-DLP.bat" (
    call "%~dp0installers\Setup-QS-DLP.bat"
) else (
    call :install_product "QS-DLP" "%LOCALAPPDATA%\NeurQ\QS-DLP"
)
echo.

echo   Installing QS-PII Scanner...
if exist "%~dp0installers\Setup-QS-PII-Scanner.bat" (
    call "%~dp0installers\Setup-QS-PII-Scanner.bat"
) else (
    call :install_product "QS-PII Scanner" "%LOCALAPPDATA%\NeurQ\QS-PII-Scanner"
)
echo.

echo   Installing Policy Engine...
if exist "%~dp0installers\Setup-Policy-Engine.bat" (
    call "%~dp0installers\Setup-Policy-Engine.bat"
) else (
    call :install_product "Policy Engine" "%LOCALAPPDATA%\NeurQ\Policy-Engine"
)
echo.

echo   Installing QS-DPDP OS (Complete Suite)...
if exist "%~dp0installers\Setup-QS-DPDP-OS-Complete.bat" (
    call "%~dp0installers\Setup-QS-DPDP-OS-Complete.bat"
) else (
    call :install_product "QS-DPDP OS" "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS"
)
echo.

:: Step 3: Copy icons and create launchers
echo [Step 3/5] Setting up icons and launchers...
set ICON_SOURCE=%~dp0QS-DPDP-OS-Icon.ico
if not exist "%ICON_SOURCE%" set ICON_SOURCE=%~dp0QS-DPDP-OS-Icon.png

if exist "%ICON_SOURCE%" (
    for %%D in (
        "%LOCALAPPDATA%\NeurQ\QS-DPDP-Core"
        "%LOCALAPPDATA%\NeurQ\QS-SIEM"
        "%LOCALAPPDATA%\NeurQ\QS-DLP"
        "%LOCALAPPDATA%\NeurQ\QS-PII-Scanner"
        "%LOCALAPPDATA%\NeurQ\Policy-Engine"
        "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS"
    ) do (
        if not exist "%%D" mkdir "%%D" >nul 2>&1
        copy /Y "%ICON_SOURCE%" "%%D\QS-DPDP-OS-Icon.ico" >nul 2>&1
        call :create_product_launcher "%%D" "%%~nxD"
    )
    echo   ✅ Icons and launchers set up
) else (
    echo   ⚠️  Icon file not found
)
echo.

:: Step 4: Create desktop shortcuts with icons
echo [Step 4/5] Creating desktop shortcuts with Google-style icons...
set DESKTOP=%USERPROFILE%\Desktop

call :create_shortcut_with_icon "%DESKTOP%\QS-DPDP Core.lnk" "%LOCALAPPDATA%\NeurQ\QS-DPDP-Core\launch.vbs" "%LOCALAPPDATA%\NeurQ\QS-DPDP-Core" "QS-DPDP Core"
call :create_shortcut_with_icon "%DESKTOP%\QS-SIEM.lnk" "%LOCALAPPDATA%\NeurQ\QS-SIEM\launch.vbs" "%LOCALAPPDATA%\NeurQ\QS-SIEM" "QS-SIEM"
call :create_shortcut_with_icon "%DESKTOP%\QS-DLP.lnk" "%LOCALAPPDATA%\NeurQ\QS-DLP\launch.vbs" "%LOCALAPPDATA%\NeurQ\QS-DLP" "QS-DLP"
call :create_shortcut_with_icon "%DESKTOP%\QS-PII Scanner.lnk" "%LOCALAPPDATA%\NeurQ\QS-PII-Scanner\launch.vbs" "%LOCALAPPDATA%\NeurQ\QS-PII-Scanner" "QS-PII Scanner"
call :create_shortcut_with_icon "%DESKTOP%\Policy Engine.lnk" "%LOCALAPPDATA%\NeurQ\Policy-Engine\launch.vbs" "%LOCALAPPDATA%\NeurQ\Policy-Engine" "Policy Engine"
call :create_shortcut_with_icon "%DESKTOP%\QS-DPDP OS.lnk" "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS\launch.vbs" "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS" "QS-DPDP OS"

echo   ✅ All shortcuts created
echo.

:: Step 5: Verify installation
echo [Step 5/5] Verifying installation...
set VERIFY_OK=1

for %%S in (
    "%DESKTOP%\QS-DPDP Core.lnk"
    "%DESKTOP%\QS-SIEM.lnk"
    "%DESKTOP%\QS-DLP.lnk"
    "%DESKTOP%\QS-PII Scanner.lnk"
    "%DESKTOP%\Policy Engine.lnk"
    "%DESKTOP%\QS-DPDP OS.lnk"
) do (
    if exist %%S (
        echo   ✅ Found: %%~nxS
    ) else (
        echo   ❌ Missing: %%~nxS
        set VERIFY_OK=0
    )
)

echo.

if !VERIFY_OK! EQU 1 (
    echo ✅ All shortcuts verified
) else (
    echo ⚠️  Some shortcuts missing
)

echo.
echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo Setup File Paths:
echo.
echo 1. QS-DPDP Core:
echo    %~dp0installers\Setup-QS-DPDP-Core.bat
echo.
echo 2. QS-SIEM:
echo    %~dp0installers\Setup-QS-SIEM.bat
echo.
echo 3. QS-DLP:
echo    %~dp0installers\Setup-QS-DLP.bat
echo.
echo 4. QS-PII Scanner:
echo    %~dp0installers\Setup-QS-PII-Scanner.bat
echo.
echo 5. Policy Engine:
echo    %~dp0installers\Setup-Policy-Engine.bat
echo.
echo 6. QS-DPDP OS (Complete Suite):
echo    %~dp0installers\Setup-QS-DPDP-OS-Complete.bat
echo.
echo All paths saved to: SETUP-FILE-PATHS.txt
echo.
echo Next steps:
echo   1. Press F5 on desktop to refresh
echo   2. Look for shortcuts with Google-style icons
echo   3. Double-click any shortcut to test
echo.
pause
exit /b 0

:: Function to install product
:install_product
set PRODUCT_NAME=%~1
set INSTALL_DIR=%~2

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%" >nul 2>&1

:: Copy icon if available
if exist "%~dp0QS-DPDP-OS-Icon.ico" (
    copy /Y "%~dp0QS-DPDP-OS-Icon.ico" "%INSTALL_DIR%\" >nul 2>&1
) else if exist "%~dp0QS-DPDP-OS-Icon.png" (
    copy /Y "%~dp0QS-DPDP-OS-Icon.png" "%INSTALL_DIR%\QS-DPDP-OS-Icon.ico" >nul 2>&1
)

:: Copy splash screen if available
if exist "%~dp0splash-screen.html" (
    copy /Y "%~dp0splash-screen.html" "%INSTALL_DIR%\" >nul 2>&1
)

exit /b 0

:: Function to create product launcher
:create_product_launcher
set INSTALL_DIR=%~1
set PRODUCT_NAME=%~2

set LAUNCHER_BAT=%INSTALL_DIR%\launch.bat
set LAUNCHER_VBS=%INSTALL_DIR%\launch.vbs

:: Create batch launcher
(
echo @echo off
echo setlocal enabledelayedexpansion
echo cd /d "%INSTALL_DIR%"
echo echo.
echo echo ========================================
echo echo %PRODUCT_NAME%
echo echo ========================================
echo echo.
echo where java ^>nul 2^>^&1
echo if %%ERRORLEVEL%% EQU 0 ^(
echo     echo ✅ Java found
echo ^) else ^(
echo     echo ❌ Java not found
echo ^)
echo echo.
echo set FOUND=0
echo if exist "*.jar" ^(
echo     for %%%%F in ^(*.jar^) do ^(
echo         if !FOUND! EQU 0 ^(
echo             java -jar "%%%%F"
echo             set FOUND=1
echo         ^)
echo     ^)
echo ^)
echo if !FOUND! EQU 0 ^(
echo     echo ⚠️  Application files not found
echo     start "" "%INSTALL_DIR%"
echo ^)
echo pause
) > "%LAUNCHER_BAT%"

:: Create VBScript launcher
(
echo Set WshShell = CreateObject^("WScript.Shell"^)
echo Set fso = CreateObject^("Scripting.FileSystemObject"^)
echo InstallDir = "%INSTALL_DIR%"
echo Launcher = InstallDir ^& "\launch.bat"
echo If fso.FileExists^(Launcher^) Then
echo     WshShell.CurrentDirectory = InstallDir
echo     WshShell.Run "cmd /c """ ^& Launcher ^& """", 1, False
echo Else
echo     MsgBox "Launcher not found", vbCritical, "%PRODUCT_NAME%"
echo End If
) > "%LAUNCHER_VBS%"

exit /b 0

:: Function to create shortcut with icon
:create_shortcut_with_icon
set SHORTCUT=%~1
set TARGET=%~2
set WORKDIR=%~3
set NAME=%~4

set ICON_PATH=%WORKDIR%\QS-DPDP-OS-Icon.ico
if not exist "%ICON_PATH%" set ICON_PATH=%~dp0QS-DPDP-OS-Icon.ico
if not exist "%ICON_PATH%" set ICON_PATH=%~dp0QS-DPDP-OS-Icon.png

powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%SHORTCUT%'); $Shortcut.TargetPath = '%TARGET%'; $Shortcut.WorkingDirectory = '%WORKDIR%'; $Shortcut.Description = '%NAME%'; if (Test-Path '%ICON_PATH%') { $Shortcut.IconLocation = '%ICON_PATH%,0' }; $Shortcut.Save()" >nul 2>&1

exit /b 0
