@echo off
REM Quick launcher for QS-DPDP OS

if exist "qs-dpdp-core\target\qs-dpdp-core-1.0.0.jar" (
    java -jar qs-dpdp-core\target\qs-dpdp-core-1.0.0.jar
) else if exist "dist\qs-dpdp-core.exe" (
    dist\qs-dpdp-core.exe
) else (
    echo ERROR: QS-DPDP OS not found. Please build the project first.
    echo Run: build-all.bat
    pause
)
