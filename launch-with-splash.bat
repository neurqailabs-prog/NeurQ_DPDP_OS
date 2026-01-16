@echo off
REM QS-DPDP OS Launcher with Splash Screen
REM Shows Visual Studio-style splash before launching main application

setlocal

set INSTALL_DIR=%~dp0
if "%INSTALL_DIR%"=="" set INSTALL_DIR=%LOCALAPPDATA%\NeurQ\QS-DPDP-OS

set JAVA_HOME=%JAVA_HOME%
if "%JAVA_HOME%"=="" (
    where java >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        set JAVA=java
    ) else (
        echo ERROR: Java not found!
        pause
        exit /b 1
    )
) else (
    set JAVA=%JAVA_HOME%\bin\java.exe
    if not exist "%JAVA%" set JAVA=java
)

REM Show splash screen first
echo Showing splash screen...
start "" "%INSTALL_DIR%\splash-screen.html"

REM Wait a moment for splash to show
timeout /t 1 /nobreak >nul

REM Launch main application
echo Launching QS-DPDP OS...
echo.

if exist "%INSTALL_DIR%\qs-dpdp-core.jar" (
    "%JAVA%" -jar "%INSTALL_DIR%\qs-dpdp-core.jar"
) else if exist "%INSTALL_DIR%\..\..\qs-dpdp-core\target\qs-dpdp-core-1.0.0.jar" (
    "%JAVA%" -jar "%INSTALL_DIR%\..\..\qs-dpdp-core\target\qs-dpdp-core-1.0.0.jar"
) else if exist "%INSTALL_DIR%\qs-dpdp-core.exe" (
    start "" "%INSTALL_DIR%\qs-dpdp-core.exe"
) else (
    echo Application files not found.
    echo Opening installation directory...
    start "" "%INSTALL_DIR%"
    pause
)

REM Close splash after app loads (if still open)
timeout /t 2 /nobreak >nul
taskkill /F /IM msedge.exe /FI "WINDOWTITLE eq *splash*" >nul 2>&1
taskkill /F /IM chrome.exe /FI "WINDOWTITLE eq *splash*" >nul 2>&1

endlocal
