@echo off
REM Deployment Script for QS-DPDP OS

echo ========================================
echo QS-DPDP OS - Deployment Script
echo ========================================
echo.

set DEPLOY_DIR=deployment
set VERSION=1.0.0

echo [1/4] Creating deployment directory...
if not exist "%DEPLOY_DIR%" mkdir "%DEPLOY_DIR%"
if not exist "%DEPLOY_DIR%\QS-DPDP-OS-%VERSION%" mkdir "%DEPLOY_DIR%\QS-DPDP-OS-%VERSION%"

echo [2/4] Copying files...
xcopy /E /I /Y "dist\executables\*" "%DEPLOY_DIR%\QS-DPDP-OS-%VERSION%\" >nul
xcopy /E /I /Y "docs\*" "%DEPLOY_DIR%\QS-DPDP-OS-%VERSION%\docs\" >nul
copy /Y "README.md" "%DEPLOY_DIR%\QS-DPDP-OS-%VERSION%\" >nul
copy /Y "START-HERE.md" "%DEPLOY_DIR%\QS-DPDP-OS-%VERSION%\" >nul
copy /Y "BUILD-AND-RUN.md" "%DEPLOY_DIR%\QS-DPDP-OS-%VERSION%\" >nul

echo [3/4] Creating deployment package...
cd "%DEPLOY_DIR%\QS-DPDP-OS-%VERSION%"
powershell -Command "Compress-Archive -Path * -DestinationPath ..\QS-DPDP-OS-%VERSION%-Deployment.zip -Force" 2>nul
cd ..\..

echo [4/4] Creating deployment manifest...
(
echo QS-DPDP Operating System - Deployment Package
echo ===============================================
echo.
echo Version: %VERSION%
echo Build Date: %DATE% %TIME%
echo.
echo Contents:
echo - Executables and launchers
echo - Documentation
echo - Build scripts
echo.
echo Installation:
echo 1. Extract this package
echo 2. Run: launch.bat
echo.
echo For full installation with installer wizard:
echo 1. Build project: build-all.bat
echo 2. Create executables: create-executables.bat
echo 3. Run installer: dist\executables\install.bat
echo.
) > "%DEPLOY_DIR%\DEPLOYMENT-README.txt"

echo.
echo ========================================
echo Deployment Package Created!
echo ========================================
echo.
echo Location: %DEPLOY_DIR%\QS-DPDP-OS-%VERSION%-Deployment.zip
echo.
echo Package includes:
echo - All executables
echo - Documentation
echo - Launcher scripts
echo.
pause
