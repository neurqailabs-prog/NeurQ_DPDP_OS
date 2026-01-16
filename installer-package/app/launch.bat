@echo off
REM QS-DPDP OS Launcher - Fixed Version
REM Actually launches the application

setlocal

set INSTALL_DIR=%~dp0
if "%INSTALL_DIR%"=="" set INSTALL_DIR=%LOCALAPPDATA%\NeurQ\QS-DPDP-OS

set JAVA_HOME=%JAVA_HOME%
if "%JAVA_HOME%"=="" (
    REM Try to find Java
    where java >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        set JAVA=java
    ) else (
        echo ERROR: Java not found!
        echo Please install Java 21+ from https://adoptium.net/
        pause
        exit /b 1
    )
) else (
    set JAVA=%JAVA_HOME%\bin\java.exe
    if not exist "%JAVA%" set JAVA=java
)

echo ========================================
echo QS-DPDP Compliance Operating System
echo ========================================
echo.
echo Starting application...
echo.

REM Check if we have JAR files
if exist "%INSTALL_DIR%\qs-dpdp-core.jar" (
    echo Launching from JAR...
    "%JAVA%" -jar "%INSTALL_DIR%\qs-dpdp-core.jar"
) else if exist "%INSTALL_DIR%\..\..\qs-dpdp-core\target\qs-dpdp-core-1.0.0.jar" (
    echo Launching from project build...
    "%JAVA%" -jar "%INSTALL_DIR%\..\..\qs-dpdp-core\target\qs-dpdp-core-1.0.0.jar"
) else if exist "%INSTALL_DIR%\qs-dpdp-core.exe" (
    echo Launching native executable...
    start "" "%INSTALL_DIR%\qs-dpdp-core.exe"
) else (
    echo.
    echo Application files not found in: %INSTALL_DIR%
    echo.
    echo To build the application:
    echo   1. Install Maven 3.8+
    echo   2. Run: build-all.bat
    echo   3. Run: create-executables.bat
    echo.
    echo For now, opening installation directory...
    start "" "%INSTALL_DIR%"
    pause
)

endlocal
