@echo off
REM Complete Build Script for QS-DPDP OS
REM Generates all executables and installers

setlocal enabledelayedexpansion

echo ========================================
echo QS-DPDP OS - Complete Build Script
echo ========================================
echo.

REM Check prerequisites
echo Checking prerequisites...
where mvn >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Maven not found. Please install Maven.
    exit /b 1
)

where cargo >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Rust/Cargo not found. Please install Rust.
    exit /b 1
)

where python >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Python not found. Please install Python 3.11+.
    exit /b 1
)

echo Prerequisites OK.
echo.

REM Step 1: Build Java modules
echo [1/6] Building Java modules...
call mvn clean install -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Java build failed!
    exit /b %ERRORLEVEL%
)
echo Java build completed.
echo.

REM Step 2: Build Rust components
echo [2/6] Building Rust components...

REM QS-SIEM Rust
if exist "qs-siem\src\main\rust" (
    echo   Building QS-SIEM Rust...
    cd qs-siem\src\main\rust
    call cargo build --release
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: QS-SIEM Rust build failed!
        cd ..\..\..\..\..
        exit /b %ERRORLEVEL%
    )
    cd ..\..\..\..\..
)

REM QS-DLP Rust
if exist "qs-dlp\src\main\rust" (
    echo   Building QS-DLP Rust...
    cd qs-dlp\src\main\rust
    call cargo build --release
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: QS-DLP Rust build failed!
        cd ..\..\..\..\..
        exit /b %ERRORLEVEL%
    )
    cd ..\..\..\..\..
)
echo Rust build completed.
echo.

REM Step 3: Build Python components
echo [3/6] Building Python components...
cd qs-pii-scanner\src\main\python
python -m pip install -r requirements.txt --quiet
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Python dependencies installation failed!
    cd ..\..\..\..\..
    exit /b %ERRORLEVEL%
)
cd ..\..\..\..\..
echo Python build completed.
echo.

REM Step 4: Create native executables with GraalVM
echo [4/6] Creating native executables with GraalVM...
if exist "%GRAALVM_HOME%\bin\native-image.cmd" (
    echo   Creating QS-DPDP Core native executable...
    call "%GRAALVM_HOME%\bin\native-image.cmd" ^
        -jar qs-dpdp-core\target\qs-dpdp-core-1.0.0.jar ^
        -H:Name=qs-dpdp-core ^
        -H:IncludeResources=".*" ^
        --no-fallback ^
        --enable-all-security-services ^
        -o dist\qs-dpdp-core.exe
    
    echo   Creating Policy Engine native executable...
    call "%GRAALVM_HOME%\bin\native-image.cmd" ^
        -jar policy-engine\target\policy-engine-1.0.0.jar ^
        -H:Name=policy-engine ^
        -H:IncludeResources=".*" ^
        --no-fallback ^
        -o dist\policy-engine.exe
) else (
    echo WARNING: GraalVM not found. Skipping native image generation.
    echo   Creating JAR executables instead...
    if not exist "dist" mkdir dist
    copy qs-dpdp-core\target\qs-dpdp-core-1.0.0.jar dist\qs-dpdp-core.jar
    copy policy-engine\target\policy-engine-1.0.0.jar dist\policy-engine.jar
)
echo Native executables created.
echo.

REM Step 5: Create installer executables
echo [5/6] Creating installers...

REM MSI Installer (Windows)
if exist "%WIX%\bin\candle.exe" (
    echo   Creating MSI installer...
    if not exist "installers\msi\output" mkdir installers\msi\output
    call "%WIX%\bin\candle.exe" installers\msi\qs-dpdp-os.wxs -o installers\msi\output\qs-dpdp-os.wixobj
    call "%WIX%\bin\light.exe" installers\msi\output\qs-dpdp-os.wixobj -o installers\msi\output\QS-DPDP-OS-1.0.0.msi
    echo   MSI installer created: installers\msi\output\QS-DPDP-OS-1.0.0.msi
) else (
    echo WARNING: WiX Toolset not found. Skipping MSI creation.
)

REM Create portable ZIP
echo   Creating portable ZIP package...
if not exist "dist\portable" mkdir dist\portable
xcopy /E /I /Y qs-dpdp-core\target\*.jar dist\portable\
xcopy /E /I /Y qs-siem\target\*.jar dist\portable\
xcopy /E /I /Y qs-dlp\target\*.jar dist\portable\
xcopy /E /I /Y qs-pii-scanner\target\*.jar dist\portable\
xcopy /E /I /Y policy-engine\target\*.jar dist\portable\
xcopy /E /I /Y licensing-engine\target\*.jar dist\portable\
xcopy /E /I /Y common\target\*.jar dist\portable\
copy /Y run.bat dist\portable\
cd dist\portable
powershell -Command "Compress-Archive -Path * -DestinationPath ..\QS-DPDP-OS-1.0.0-portable.zip -Force"
cd ..\..
echo   Portable ZIP created: dist\QS-DPDP-OS-1.0.0-portable.zip
echo.

REM Step 6: Generate documentation
echo [6/6] Generating documentation...
call mvn javadoc:aggregate
if %ERRORLEVEL% EQU 0 (
    echo Documentation generated in target\site\apidocs
)
echo.

echo ========================================
echo Build completed successfully!
echo ========================================
echo.
echo Output files:
echo   - Executables: dist\
echo   - Installers: installers\msi\output\
echo   - Documentation: target\site\apidocs\
echo.
pause
