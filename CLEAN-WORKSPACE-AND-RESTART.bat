@echo off
REM ========================================
REM Clean Workspace and Restart Fresh
REM ========================================

setlocal enabledelayedexpansion

echo.
echo ========================================
echo CLEANING WORKSPACE AND SYSTEM
echo ========================================
echo.

echo [Step 1/5] Stopping all running processes...
taskkill /F /IM java.exe /T >nul 2>&1
taskkill /F /IM javaw.exe /T >nul 2>&1
taskkill /F /IM mvn.cmd /T >nul 2>&1
echo   ✅ Processes stopped
echo.

echo [Step 2/5] Removing unnecessary files...
REM Keep only essential source code and remove temporary files
for /R %%F in (*.log,*.tmp,*.bak,*~,*_OLD.*) do (
    if exist "%%F" del /F /Q "%%F" >nul 2>&1
)
REM Remove duplicate documentation files (keep only README.md and key docs)
for /R %%F in (*-COMPLETE*.md,*FINAL*.md,*STATUS*.md,*SUMMARY*.md,*REPORT*.md) do (
    if not "%%~nxF"=="README.md" if not "%%~nxF"=="COMPLETE-FINAL-IMPLEMENTATION-SUMMARY.md" del /F /Q "%%F" >nul 2>&1
)
REM Remove test/debug batch files (keep only essential)
for /R %%F in (test-*.bat,FIX-*.bat,create-*.bat,fix-*.bat,update-*.bat) do (
    del /F /Q "%%F" >nul 2>&1
)
echo   ✅ Unnecessary files removed
echo.

echo [Step 3/5] Removing build artifacts...
if exist "target" rmdir /S /Q "target" >nul 2>&1
if exist "build" rmdir /S /Q "build" >nul 2>&1
if exist "dist" rmdir /S /Q "dist" >nul 2>&1
for /D /R %%D in (target,build,dist) do (
    if exist "%%D" rmdir /S /Q "%%D" >nul 2>&1
)
echo   ✅ Build artifacts removed
echo.

echo [Step 4/5] Cleaning installation directories...
for %%D in (
    "%LOCALAPPDATA%\NeurQ\QS-DPDP-Core"
    "%LOCALAPPDATA%\NeurQ\QS-SIEM"
    "%LOCALAPPDATA%\NeurQ\QS-DLP"
    "%LOCALAPPDATA%\NeurQ\QS-PII-Scanner"
    "%LOCALAPPDATA%\NeurQ\Policy-Engine"
    "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS"
) do (
    if exist "%%D" rmdir /S /Q "%%D" >nul 2>&1
)
echo   ✅ Installation directories cleaned
echo.

echo [Step 5/5] Removing desktop shortcuts...
set DESKTOP=%USERPROFILE%\Desktop
for %%S in (
    "QS-DPDP Core.lnk"
    "QS-SIEM.lnk"
    "QS-DLP.lnk"
    "QS-PII Scanner.lnk"
    "Policy Engine.lnk"
    "QS-DPDP OS.lnk"
) do (
    if exist "%DESKTOP%\%%S" del /F /Q "%DESKTOP%\%%S" >nul 2>&1
)
echo   ✅ Desktop shortcuts removed
echo.

echo ========================================
echo ✅ WORKSPACE CLEANED - READY FOR FRESH BUILD
echo ========================================
echo.
echo Workspace is now clean and ready for new implementation.
echo.
pause
