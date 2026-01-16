@echo off
REM ========================================
REM Run All Product Tests
REM ========================================
REM This runs all test scripts one by one

echo.
echo ========================================
echo Running All Product Tests
echo ========================================
echo.
echo This will test each product one by one.
echo.
echo Products to test:
echo   1. QS-DPDP Core
echo   2. QS-SIEM
echo   3. QS-DLP
echo   4. QS-PII Scanner
echo   5. Policy Engine
echo   6. QS-DPDP OS (Complete Suite)
echo.
echo Press any key to start...
pause
echo.

call test-qs-dpdp-core.bat
echo.
echo ========================================
echo.
pause

call test-qs-siem.bat
echo.
echo ========================================
echo.
pause

call test-qs-dlp.bat
echo.
echo ========================================
echo.
pause

call test-qs-pii-scanner.bat
echo.
echo ========================================
echo.
pause

call test-policy-engine.bat
echo.
echo ========================================
echo.
pause

call test-qs-dpdp-os.bat
echo.
echo ========================================
echo.
echo All tests complete!
echo.
echo Check your desktop for "Manual" shortcuts.
echo Test each one and report back what happens.
echo.
pause
