@echo off
REM Build script for QS-DPDP OS (Windows)

echo Building QS-DPDP Operating System...

REM Build Java modules
echo Building Java modules...
call mvn clean install -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo Maven build failed!
    exit /b %ERRORLEVEL%
)

REM Build Rust components
echo Building Rust components...

REM QS-SIEM Rust
if exist "qs-siem\src\main\rust" (
    echo Building QS-SIEM Rust...
    cd qs-siem\src\main\rust
    call cargo build --release
    if %ERRORLEVEL% NEQ 0 (
        echo Rust build failed!
        exit /b %ERRORLEVEL%
    )
    cd ..\..\..\..\..
)

REM QS-DLP Rust
if exist "qs-dlp\src\main\rust" (
    echo Building QS-DLP Rust...
    cd qs-dlp\src\main\rust
    call cargo build --release
    if %ERRORLEVEL% NEQ 0 (
        echo Rust build failed!
        exit /b %ERRORLEVEL%
    )
    cd ..\..\..\..\..
)

echo Build completed successfully!
