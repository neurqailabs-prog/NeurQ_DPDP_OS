@echo off
REM ========================================
REM Final Launcher Fix - Correct Syntax
REM ========================================

setlocal enabledelayedexpansion

echo Fixing all launchers with correct syntax...

:: Fix all launcher files
call :fix_launcher "%LOCALAPPDATA%\NeurQ\QS-DPDP-Core\launch.bat" "%LOCALAPPDATA%\NeurQ\QS-DPDP-Core" "QS-DPDP Core"
call :fix_launcher "%LOCALAPPDATA%\NeurQ\QS-SIEM\launch.bat" "%LOCALAPPDATA%\NeurQ\QS-SIEM" "QS-SIEM"
call :fix_launcher "%LOCALAPPDATA%\NeurQ\QS-DLP\launch.bat" "%LOCALAPPDATA%\NeurQ\QS-DLP" "QS-DLP"
call :fix_launcher "%LOCALAPPDATA%\NeurQ\QS-PII-Scanner\launch.bat" "%LOCALAPPDATA%\NeurQ\QS-PII-Scanner" "QS-PII Scanner"
call :fix_launcher "%LOCALAPPDATA%\NeurQ\Policy-Engine\launch.bat" "%LOCALAPPDATA%\NeurQ\Policy-Engine" "Policy Engine"
call :fix_suite_launcher "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS\launch.bat" "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS"

echo.
echo ✅ All launchers fixed!
echo.
echo Test your desktop shortcuts now - they should work!
echo.
pause
exit /b 0

:: Function to fix individual launcher
:fix_launcher
set LAUNCHER=%~1
set INSTALL_DIR=%~2
set PRODUCT_NAME=%~3

(
echo @echo off
echo REM %PRODUCT_NAME% Launcher - Working Version
echo setlocal enabledelayedexpansion
echo.
echo cd /d "%INSTALL_DIR%"
echo.
echo echo ========================================
echo echo Starting %PRODUCT_NAME%...
echo echo ========================================
echo echo.
echo.
echo REM Check Java
echo where java ^>nul 2^>^&1
echo if %%ERRORLEVEL%% NEQ 0 ^(
echo     echo ERROR: Java 21+ required!
echo     echo Please install Java from https://adoptium.net/
echo     pause
echo     exit /b 1
echo ^)
echo.
echo REM Show splash screen
echo if exist "splash-screen.html" ^(
echo     start "" "splash-screen.html"
echo ^)
echo.
echo REM Find and launch JAR/EXE
echo set FOUND=0
echo.
echo REM Check for JAR files
echo if exist "*.jar" ^(
echo     for %%F in ^(*.jar^) do ^(
echo         if !FOUND! EQU 0 ^(
echo             echo Launching application from %%F...
echo             java -jar "%%F"
echo             set FOUND=1
echo         ^)
echo     ^)
echo ^)
echo.
echo REM Check for EXE files
echo if exist "*.exe" ^(
echo     for %%F in ^(*.exe^) do ^(
echo         if !FOUND! EQU 0 ^(
echo             echo Launching application from %%F...
echo             start "" "%%F"
echo             set FOUND=1
echo         ^)
echo     ^)
echo ^)
echo.
echo REM Try project directory
echo if !FOUND! EQU 0 ^(
echo     set PROJ_DIR=D:\NeurQ_DPDP_Cursor_15012026
echo     if exist "!PROJ_DIR!\qs-dpdp-core\target\qs-dpdp-core-1.0.0.jar" ^(
echo         echo Launching from project directory...
echo         java -jar "!PROJ_DIR!\qs-dpdp-core\target\qs-dpdp-core-1.0.0.jar"
echo         set FOUND=1
echo     ^)
echo ^)
echo.
echo REM If not found, show message
echo if !FOUND! EQU 0 ^(
echo     echo.
echo     echo ========================================
echo     echo Application Files Not Found
echo     echo ========================================
echo     echo.
echo     echo Application JAR or EXE file not found.
echo     echo.
echo     echo Opening installation directory...
echo     start "" "%INSTALL_DIR%"
echo     pause
echo ^)
echo.
echo endlocal
) > "%LAUNCHER%"

exit /b 0

:: Function to fix suite launcher
:fix_suite_launcher
set LAUNCHER=%~1
set INSTALL_DIR=%~2

(
echo @echo off
echo REM QS-DPDP OS Complete Suite Launcher - Working Version
echo setlocal enabledelayedexpansion
echo.
echo cd /d "%INSTALL_DIR%"
echo.
echo echo ========================================
echo echo Starting QS-DPDP OS Complete Suite...
echo echo ========================================
echo echo.
echo.
echo REM Check Java
echo where java ^>nul 2^>^&1
echo if %%ERRORLEVEL%% NEQ 0 ^(
echo     echo ERROR: Java 21+ required!
echo     echo Please install Java from https://adoptium.net/
echo     pause
echo     exit /b 1
echo ^)
echo.
echo REM Show splash screen
echo if exist "splash-screen.html" ^(
echo     start "" "splash-screen.html"
echo ^)
echo.
echo REM Find and launch JAR/EXE
echo set FOUND=0
echo.
echo REM Try core directory first
echo if exist "core\*.jar" ^(
echo     for %%F in ^(core\*.jar^) do ^(
echo         if !FOUND! EQU 0 ^(
echo             echo Launching QS-DPDP OS from %%F...
echo             java -jar "%%F"
echo             set FOUND=1
echo         ^)
echo     ^)
echo ^)
echo.
echo REM Try root directory
echo if exist "*.jar" ^(
echo     for %%F in ^(*.jar^) do ^(
echo         if !FOUND! EQU 0 ^(
echo             echo Launching QS-DPDP OS from %%F...
echo             java -jar "%%F"
echo             set FOUND=1
echo         ^)
echo     ^)
echo ^)
echo.
echo REM Try executable
echo if exist "*.exe" ^(
echo     for %%F in ^(*.exe^) do ^(
echo         if !FOUND! EQU 0 ^(
echo             echo Launching QS-DPDP OS from %%F...
echo             start "" "%%F"
echo             set FOUND=1
echo         ^)
echo     ^)
echo ^)
echo.
echo REM Try project directory
echo if !FOUND! EQU 0 ^(
echo     set PROJ_DIR=D:\NeurQ_DPDP_Cursor_15012026
echo     if exist "!PROJ_DIR!\qs-dpdp-core\target\qs-dpdp-core-1.0.0.jar" ^(
echo         echo Launching from project directory...
echo         java -jar "!PROJ_DIR!\qs-dpdp-core\target\qs-dpdp-core-1.0.0.jar"
echo         set FOUND=1
echo     ^)
echo ^)
echo.
echo REM If not found, show message
echo if !FOUND! EQU 0 ^(
echo     echo.
echo     echo ========================================
echo     echo Application Files Not Found
echo     echo ========================================
echo     echo.
echo     echo Application files not found.
echo     echo Opening installation directory...
echo     start "" "%INSTALL_DIR%"
echo     pause
echo ^)
echo.
echo endlocal
) > "%LAUNCHER%"

exit /b 0
