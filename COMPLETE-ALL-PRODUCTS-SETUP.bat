@echo off
REM ========================================
REM Complete Setup for All Products
REM ========================================
REM Creates VBScript launchers for all 6 products

setlocal enabledelayedexpansion

echo.
echo ========================================
echo Complete Setup for All Products
echo ========================================
echo.

:: Product 1: QS-DPDP Core
echo [1/6] Setting up QS-DPDP Core...
call :setup_product "QS-DPDP Core" "%LOCALAPPDATA%\NeurQ\QS-DPDP-Core"
echo   ✅ QS-DPDP Core ready
echo.

:: Product 2: QS-SIEM
echo [2/6] Setting up QS-SIEM...
call :setup_product "QS-SIEM" "%LOCALAPPDATA%\NeurQ\QS-SIEM"
echo   ✅ QS-SIEM ready
echo.

:: Product 3: QS-DLP
echo [3/6] Setting up QS-DLP...
call :setup_product "QS-DLP" "%LOCALAPPDATA%\NeurQ\QS-DLP"
echo   ✅ QS-DLP ready
echo.

:: Product 4: QS-PII Scanner
echo [4/6] Setting up QS-PII Scanner...
call :setup_product "QS-PII Scanner" "%LOCALAPPDATA%\NeurQ\QS-PII-Scanner"
echo   ✅ QS-PII Scanner ready
echo.

:: Product 5: Policy Engine
echo [5/6] Setting up Policy Engine...
call :setup_product "Policy Engine" "%LOCALAPPDATA%\NeurQ\Policy-Engine"
echo   ✅ Policy Engine ready
echo.

:: Product 6: QS-DPDP OS (Complete Suite)
echo [6/6] Setting up QS-DPDP OS...
call :setup_product "QS-DPDP OS" "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS"
echo   ✅ QS-DPDP OS ready
echo.

echo ========================================
echo Setup Complete for All Products!
echo ========================================
echo.
echo Created:
echo   ✅ VBScript launchers for all 6 products
echo   ✅ Batch launchers for all 6 products
echo   ✅ Desktop shortcuts for all 6 products
echo.
echo Products ready:
echo   1. QS-DPDP Core
echo   2. QS-SIEM
echo   3. QS-DLP
echo   4. QS-PII Scanner
echo   5. Policy Engine
echo   6. QS-DPDP OS
echo.
echo Next steps:
echo   1. Press F5 on desktop to refresh
echo   2. Look for all 6 shortcuts on desktop
echo   3. Double-click any shortcut to test
echo   4. They should all work now!
echo.
pause
exit /b 0

:: Function to setup a product
:setup_product
set PRODUCT_NAME=%~1
set INSTALL_DIR=%~2
set LAUNCHER_BAT=%INSTALL_DIR%\launch.bat
set LAUNCHER_VBS=%INSTALL_DIR%\launch.vbs
set DESKTOP=%USERPROFILE%\Desktop
set SHORTCUT=%DESKTOP%\%PRODUCT_NAME%.lnk

:: Ensure directory exists
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%" >nul 2>&1

:: Create VBScript launcher
(
echo Set WshShell = CreateObject^("WScript.Shell"^)
echo Set fso = CreateObject^("Scripting.FileSystemObject"^)
echo.
echo InstallDir = "%INSTALL_DIR%"
echo Launcher = InstallDir ^& "\launch.bat"
echo.
echo If fso.FileExists^(Launcher^) Then
echo     WshShell.CurrentDirectory = InstallDir
echo     WshShell.Run "cmd /c """ ^& Launcher ^& """", 1, False
echo Else
echo     MsgBox "Launcher not found at: " ^& Launcher, vbCritical, "%PRODUCT_NAME% - Error"
echo End If
) > "%LAUNCHER_VBS%"

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
echo echo Installation: %INSTALL_DIR%
echo echo.
echo echo Checking for Java...
echo where java ^>nul 2^>^&1
echo if %%ERRORLEVEL%% EQU 0 ^(
echo     echo ✅ Java found
echo     java -version
echo ^) else ^(
echo     echo ❌ Java not found
echo     echo Please install Java 21+ from https://adoptium.net/
echo ^)
echo echo.
echo echo Checking for application files...
echo echo.
echo set FOUND=0
echo.
echo if exist "*.jar" ^(
echo     echo ✅ JAR files found
echo     for %%%%F in ^(*.jar^) do ^(
echo         if !FOUND! EQU 0 ^(
echo             echo Launching %%%%F...
echo             java -jar "%%%%F"
echo             set FOUND=1
echo         ^)
echo     ^)
echo ^)
echo.
echo if exist "*.exe" ^(
echo     echo ✅ EXE files found
echo     for %%%%F in ^(*.exe^) do ^(
echo         if !FOUND! EQU 0 ^(
echo             echo Launching %%%%F...
echo             start "" "%%%%F"
echo             set FOUND=1
echo         ^)
echo     ^)
echo ^)
echo.
echo if !FOUND! EQU 0 ^(
echo     echo.
echo     echo ⚠️  Application files not found
echo     echo.
echo     echo This is normal if the application hasn't been built yet.
echo     echo.
echo     echo Opening installation directory...
echo     start "" "%INSTALL_DIR%"
echo ^)
echo.
echo pause
) > "%LAUNCHER_BAT%"

:: Create shortcut pointing to VBScript
if exist "%SHORTCUT%" del "%SHORTCUT%" >nul 2>&1

powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%SHORTCUT%'); $Shortcut.TargetPath = '%LAUNCHER_VBS%'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.Description = '%PRODUCT_NAME% - Quantum-Safe DPDP Compliance System'; $Shortcut.Save()" >nul 2>&1

exit /b 0
