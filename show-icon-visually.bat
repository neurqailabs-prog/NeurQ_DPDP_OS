@echo off
REM Show Icon Visually - Opens Icon File to Verify

echo ========================================
echo QS-DPDP OS - Show Icon Visually
echo ========================================
echo.

set ICON_FILE=%~dp0QS-DPDP-OS-Icon.ico
set PNG_FILE=%~dp0QS-DPDP-OS-Icon.png

echo Opening icon files to verify they exist...
echo.

if exist "%ICON_FILE%" (
    echo ✅ ICO file found - opening...
    start "" "%ICON_FILE%"
    timeout /t 1 /nobreak >nul
) else (
    echo ❌ ICO file not found
)

if exist "%PNG_FILE%" (
    echo ✅ PNG file found - opening...
    start "" "%PNG_FILE%"
) else (
    echo ❌ PNG file not found
)

echo.
echo If the icon files opened, you can see the design.
echo.
echo The icon should show:
echo   - Multi-color "QS" text (Google style)
echo   - "DPDP OS" at bottom
echo   - Quantum-safe purple/blue background
echo   - AI badge
echo.
echo Now let's apply it to the shortcut...
echo.
pause

call fix-icon-now.bat
