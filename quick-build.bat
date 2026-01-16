@echo off
REM Quick Build Script - Compiles Java files directly without Maven

echo ========================================
echo QS-DPDP OS - Quick Build
echo ========================================
echo.

set JAVA_HOME=%JAVA_HOME%
if "%JAVA_HOME%"=="" set JAVA_HOME=C:\Program Files\Microsoft\jdk-21.0.9.10-hotspot

set JAVAC=%JAVA_HOME%\bin\javac.exe
set JAVA=%JAVA_HOME%\bin\java.exe

if not exist "%JAVAC%" (
    echo ERROR: Java compiler not found at %JAVAC%
    echo Trying to find javac in PATH...
    where javac >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Java compiler not found!
        exit /b 1
    )
    set JAVAC=javac
    set JAVA=java
)

echo Using Java: %JAVA%
echo.

REM Create output directories
if not exist "build\classes" mkdir build\classes
if not exist "dist\executables" mkdir dist\executables
if not exist "dist\executables\lib" mkdir dist\executables\lib

echo [1/5] Compiling Common module...
"%JAVAC%" -d build\classes -encoding UTF-8 ^
    common\src\main\java\com\neurq\common\crypto\*.java ^
    common\src\main\java\com\neurq\common\i18n\*.java ^
    2>build-errors.log
if %ERRORLEVEL% NEQ 0 (
    echo WARNING: Some compilation errors (check build-errors.log)
) else (
    echo   Common module compiled
)

echo [2/5] Creating JAR files...
cd build\classes
"%JAVA_HOME%\bin\jar.exe" cf ..\..\dist\executables\lib\common.jar com\neurq\common\* 2>nul
cd ..\..

echo [3/5] Creating launcher scripts...
(
echo @echo off
echo REM QS-DPDP OS Launcher
echo echo Starting QS-DPDP Compliance Operating System...
echo echo.
echo echo Note: Full build requires Maven for dependencies.
echo echo This is a quick launcher. For full functionality, run:
echo echo   build-all.bat
echo echo.
echo pause
) > dist\executables\launch.bat

(
echo @echo off
echo REM QS-DPDP OS Installer Launcher
echo echo Starting QS-DPDP OS Installer...
echo echo.
echo echo Note: Full installer requires Maven build.
echo echo For full installation, run:
echo echo   build-all.bat
echo echo   create-executables.bat
echo echo.
echo pause
) > dist\executables\install.bat

echo [4/5] Creating deployment package...
cd dist\executables
powershell -Command "Compress-Archive -Path * -DestinationPath ..\QS-DPDP-OS-Quick-Build.zip -Force" 2>nul
cd ..\..

echo [5/5] Creating deployment manifest...
(
echo QS-DPDP OS - Quick Build Package
echo =================================
echo.
echo Build Date: %DATE% %TIME%
echo Java Version: Java 21
echo.
echo Contents:
echo - Launcher scripts
echo - Build structure
echo.
echo To complete full build:
echo 1. Install Maven 3.8+
echo 2. Run: build-all.bat
echo 3. Run: create-executables.bat
echo.
echo This quick build creates the basic structure.
echo Full functionality requires Maven for dependency management.
) > dist\BUILD-INFO.txt

echo.
echo ========================================
echo Quick Build Completed!
echo ========================================
echo.
echo Output: dist\executables\
echo Package: dist\QS-DPDP-OS-Quick-Build.zip
echo.
echo Note: This is a structure-only build.
echo For full build with dependencies, install Maven and run build-all.bat
echo.
