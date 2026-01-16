@echo off
REM Project Verification Script
REM Checks that all required files are present

echo ========================================
echo QS-DPDP OS Project Verification
echo ========================================
echo.

set ERRORS=0

echo Checking project structure...
echo.

REM Check root POM
if not exist "pom.xml" (
    echo [ERROR] Root pom.xml not found!
    set /a ERRORS+=1
) else (
    echo [OK] Root pom.xml found
)

REM Check module POMs
echo.
echo Checking module POM files...
for %%m in (common licensing-engine qs-dpdp-core qs-siem qs-dlp qs-pii-scanner policy-engine) do (
    if exist "%%m\pom.xml" (
        echo [OK] %%m\pom.xml
    ) else (
        echo [ERROR] %%m\pom.xml not found!
        set /a ERRORS+=1
    )
)

REM Check core Java files
echo.
echo Checking core Java modules...
if exist "common\src\main\java\com\neurq\common\crypto\QuantumSafeCrypto.java" (
    echo [OK] QuantumSafeCrypto.java
) else (
    echo [ERROR] QuantumSafeCrypto.java not found!
    set /a ERRORS+=1
)

if exist "common\src\main\java\com\neurq\common\i18n\I18nManager.java" (
    echo [OK] I18nManager.java
) else (
    echo [ERROR] I18nManager.java not found!
    set /a ERRORS+=1
)

if exist "licensing-engine\src\main\java\com\neurq\licensing\LicenseManager.java" (
    echo [OK] LicenseManager.java
) else (
    echo [ERROR] LicenseManager.java not found!
    set /a ERRORS+=1
)

if exist "qs-dpdp-core\src\main\java\com\neurq\dpdp\core\MainApplication.java" (
    echo [OK] MainApplication.java
) else (
    echo [ERROR] MainApplication.java not found!
    set /a ERRORS+=1
)

REM Check Rust files
echo.
echo Checking Rust modules...
if exist "qs-siem\src\main\rust\src\main.rs" (
    echo [OK] qs-siem Rust module
) else (
    echo [ERROR] qs-siem Rust module missing
    set /a ERRORS+=1
)

if exist "qs-dlp\src\main\rust\src\main.rs" (
    echo [OK] qs-dlp Rust module
) else (
    echo [ERROR] qs-dlp Rust module missing
    set /a ERRORS+=1
)

REM Check Python files
echo.
echo Checking Python modules...
if exist "qs-pii-scanner\src\main\python\pii_scanner.py" (
    echo [OK] pii_scanner.py
) else (
    echo [ERROR] pii_scanner.py not found!
    set /a ERRORS+=1
)

if exist "qs-pii-scanner\src\main\python\requirements.txt" (
    echo [OK] requirements.txt
) else (
    echo [ERROR] requirements.txt not found!
    set /a ERRORS+=1
)

REM Check build scripts
echo.
echo Checking build scripts...
if exist "build-all.bat" (
    echo [OK] build-all.bat
) else (
    echo [ERROR] build-all.bat not found!
    set /a ERRORS+=1
)

if exist "create-executables.bat" (
    echo [OK] create-executables.bat
) else (
    echo [ERROR] create-executables.bat not found!
    set /a ERRORS+=1
)

REM Check documentation
echo.
echo Checking documentation...
if exist "README.md" (
    echo [OK] README.md
) else (
    echo [WARNING] README.md not found
)

if exist "START-HERE.md" (
    echo [OK] START-HERE.md
) else (
    echo [WARNING] START-HERE.md not found
)

REM Check demo data
echo.
echo Checking demo data...
if exist "demo-data\sqlite\schema.sql" (
    echo [OK] Database schema
) else (
    echo [WARNING] Database schema not found
)

if exist "demo-data\sqlite\demo-data.sql" (
    echo [OK] Demo data
) else (
    echo [WARNING] Demo data not found
)

REM Check installer
echo.
echo Checking installer...
if exist "installers\installer-wizard\src\main\java\com\neurq\installer\InstallerWizard.java" (
    echo [OK] InstallerWizard.java
) else (
    echo [WARNING] InstallerWizard.java not found
)

echo.
echo ========================================
if %ERRORS% EQU 0 (
    echo Verification PASSED - All critical files present!
    echo.
    echo Project is ready to build.
    echo Run: build-all.bat
) else (
    echo Verification FAILED - %ERRORS% error(s) found!
    echo Please fix the errors before building.
)
echo ========================================
echo.

pause
