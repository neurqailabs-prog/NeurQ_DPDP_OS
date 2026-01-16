@echo off
REM Run QS-DPDP OS Application

echo ========================================
echo QS-DPDP Compliance Operating System
echo ========================================
echo.

set JAVA_HOME=%JAVA_HOME%
if "%JAVA_HOME%"=="" set JAVA_HOME=C:\Program Files\Microsoft\jdk-21.0.9.10-hotspot

set JAVA=%JAVA_HOME%\bin\java.exe

if not exist "%JAVA%" (
    where java >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Java not found!
        pause
        exit /b 1
    )
    set JAVA=java
)

echo Starting QS-DPDP OS...
echo.

REM Check if we have compiled classes
if exist "build\classes\com\neurq\dpdp\core\MainApplication.class" (
    echo Running from compiled classes...
    "%JAVA%" -cp "build\classes;dist\executables\lib\*" com.neurq.dpdp.core.MainApplication
) else if exist "dist\executables\qs-dpdp-core.jar" (
    echo Running from JAR...
    "%JAVA%" -jar dist\executables\qs-dpdp-core.jar
) else if exist "dist\executables\qs-dpdp-core.exe" (
    echo Running native executable...
    start dist\executables\qs-dpdp-core.exe
) else (
    echo.
    echo Application not built yet.
    echo.
    echo To build and run:
    echo   1. Install Maven 3.8+
    echo   2. Run: build-all.bat
    echo   3. Run: create-executables.bat
    echo   4. Run: dist\executables\launch.bat
    echo.
    echo Or run quick build:
    echo   quick-build.bat
    echo.
    pause
)
