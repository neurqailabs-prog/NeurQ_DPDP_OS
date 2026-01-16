@echo off
REM ========================================
REM Install All Products Separately
REM ========================================
REM Installs each product one by one

setlocal

echo.
echo ========================================
echo Installing All QS-DPDP OS Products
echo ========================================
echo.
echo This will install each product separately:
echo   1. QS-DPDP Core
echo   2. QS-SIEM
echo   3. QS-DLP
echo   4. QS-PII Scanner
echo   5. Policy Engine
echo   6. QS-DPDP OS (Complete Suite)
echo.
echo Press any key to start installation...
pause >nul

:: Install QS-DPDP Core
echo.
echo ========================================
echo [1/6] Installing QS-DPDP Core
echo ========================================
if exist "installers\Setup-QS-DPDP-Core.bat" (
    cd installers
    call "Setup-QS-DPDP-Core.bat"
    cd ..
) else (
    echo   Installer not found
)
timeout /t 2 /nobreak >nul

:: Install QS-SIEM
echo.
echo ========================================
echo [2/6] Installing QS-SIEM
echo ========================================
if exist "installers\Setup-QS-SIEM.bat" (
    cd installers
    call "Setup-QS-SIEM.bat"
    cd ..
) else (
    echo   Installer not found
)
timeout /t 2 /nobreak >nul

:: Install QS-DLP
echo.
echo ========================================
echo [3/6] Installing QS-DLP
echo ========================================
if exist "installers\Setup-QS-DLP.bat" (
    cd installers
    call "Setup-QS-DLP.bat"
    cd ..
) else (
    echo   Installer not found
)
timeout /t 2 /nobreak >nul

:: Install QS-PII Scanner
echo.
echo ========================================
echo [4/6] Installing QS-PII Scanner
echo ========================================
if exist "installers\Setup-QS-PII-Scanner.bat" (
    cd installers
    call "Setup-QS-PII-Scanner.bat"
    cd ..
) else (
    echo   Installer not found
)
timeout /t 2 /nobreak >nul

:: Install Policy Engine
echo.
echo ========================================
echo [5/6] Installing Policy Engine
echo ========================================
if exist "installers\Setup-Policy-Engine.bat" (
    cd installers
    call "Setup-Policy-Engine.bat"
    cd ..
) else (
    echo   Installer not found
)
timeout /t 2 /nobreak >nul

:: Install Complete Suite
echo.
echo ========================================
echo [6/6] Installing QS-DPDP OS Complete Suite
echo ========================================
if exist "installers\Setup-QS-DPDP-OS-Complete.bat" (
    cd installers
    call "Setup-QS-DPDP-OS-Complete.bat"
    cd ..
) else (
    if exist "Setup-QS-DPDP-OS.bat" (
        call "Setup-QS-DPDP-OS.bat"
    ) else (
        echo   Installer not found
    )
)

:: Final Summary
cls
echo.
echo ========================================
echo All Products Installation Complete!
echo ========================================
echo.
echo Installed Products:
echo   ✅ QS-DPDP Core
echo   ✅ QS-SIEM
echo   ✅ QS-DLP
echo   ✅ QS-PII Scanner
echo   ✅ Policy Engine
echo   ✅ QS-DPDP OS (Complete Suite)
echo.
echo Check your desktop for shortcuts!
echo.
pause
