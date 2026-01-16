@echo off
REM ========================================
REM QS-DPDP OS - Prerequisites Setup
REM ========================================
REM Installs all required prerequisites

setlocal enabledelayedexpansion

echo.
echo ========================================
echo QS-DPDP OS - Prerequisites Setup
echo ========================================
echo.

:: Check and install Java
echo [1/4] Checking Java...
where java >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo   Java not found. Please install Java 21+ from:
    echo   https://adoptium.net/
    echo.
    echo   Opening download page...
    start https://adoptium.net/
    pause
) else (
    java -version
    echo   ✅ Java is installed
)

:: Check and install Maven
echo.
echo [2/4] Checking Maven...
where mvn >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo   Maven not found. Please install Maven 3.8+ from:
    echo   https://maven.apache.org/download.cgi
    echo.
    echo   Opening download page...
    start https://maven.apache.org/download.cgi
    pause
) else (
    mvn --version
    echo   ✅ Maven is installed
)

:: Check and install Rust
echo.
echo [3/4] Checking Rust...
where rustc >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo   Rust not found. Please install Rust from:
    echo   https://rustup.rs/
    echo.
    echo   Opening download page...
    start https://rustup.rs/
    pause
) else (
    rustc --version
    echo   ✅ Rust is installed
)

:: Check and install Python
echo.
echo [4/4] Checking Python...
where python >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo   Python not found. Please install Python 3.11+ from:
    echo   https://www.python.org/downloads/
    echo.
    echo   Opening download page...
    start https://www.python.org/downloads/
    pause
) else (
    python --version
    echo   ✅ Python is installed
)

echo.
echo ========================================
echo Prerequisites Check Complete
echo ========================================
echo.
echo If all prerequisites are installed, run:
echo   deploy-complete-solution.bat
echo.
pause
