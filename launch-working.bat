@echo off
REM Working Launcher - Actually Launches Application
setlocal

cd /d "%~dp0"

echo ========================================
echo QS-DPDP OS
echo ========================================
echo.
echo Starting application...
echo.

REM Check Java
where java >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Java not found!
    echo Please install Java 21+ from https://adoptium.net/
    pause
    exit /b 1
)

REM Show splash screen
if exist "splash-screen.html" (
    start "" "splash-screen.html"
    timeout /t 2 /nobreak >nul
)

REM Find and launch JAR file
set JAR_FOUND=0

if exist "core\qs-dpdp-core-1.0.0.jar" (
    echo Launching from core directory...
    java -jar "core\qs-dpdp-core-1.0.0.jar"
    set JAR_FOUND=1
) else if exist "qs-dpdp-core-1.0.0.jar" (
    echo Launching from root directory...
    java -jar "qs-dpdp-core-1.0.0.jar"
    set JAR_FOUND=1
) else if exist "*.jar" (
    echo Launching first JAR found...
    for %F in (*.jar) do (
        java -jar "%F"
        set JAR_FOUND=1
        goto :jar_launched
    )
    :jar_launched
) else if exist "*.exe" (
    echo Launching executable...
    for %F in (*.exe) do (
        start "" "%F"
        set JAR_FOUND=1
        goto :exe_launched
    )
    :exe_launched
)

if %JAR_FOUND% EQU 0 (
    echo.
    echo ========================================
    echo Application Not Found
    echo ========================================
    echo.
    echo Application JAR or EXE file not found.
    echo.
    echo The application needs to be built first.
    echo.
    echo Opening installation directory...
    start "" "%~dp0"
    pause
)

endlocal
