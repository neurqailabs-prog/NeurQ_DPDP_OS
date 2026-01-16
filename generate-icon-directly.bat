@echo off
REM Generate Custom Icon Directly and Update Shortcut

echo ========================================
echo QS-DPDP OS - Generate Custom Icon
echo ========================================
echo.

set DESKTOP=%USERPROFILE%\Desktop
set SHORTCUT=%DESKTOP%\QS-DPDP OS.lnk
set ICON_DIR=%~dp0
set ICON_FILE=%ICON_DIR%QS-DPDP-OS-Icon.ico

echo [1/3] Opening icon generator...
start "" "create-custom-icon.html"
timeout /t 2 /nobreak >nul

echo [2/3] Instructions:
echo.
echo In the browser window:
echo   1. Click "Download Icon (PNG)" button
echo   2. Save the file
echo   3. Press any key here after downloading
echo.
pause

echo [3/3] Converting to ICO and updating shortcut...
echo.

REM Check if PNG was downloaded to Downloads folder
set DOWNLOADS=%USERPROFILE%\Downloads
set PNG_FILE=%DOWNLOADS%\QS-DPDP-OS-Icon.png

if exist "%PNG_FILE%" (
    echo Found PNG file, converting to ICO...
    REM Use PowerShell to convert PNG to ICO
    powershell -Command "$img = [System.Drawing.Image]::FromFile('%PNG_FILE%'); $ico = New-Object System.Drawing.IconConverter; $bytes = $ico.ConvertTo($img, [System.Drawing.Icon], $null); [System.IO.File]::WriteAllBytes('%ICON_FILE%', $bytes); $img.Dispose()"
    
    if exist "%ICON_FILE%" (
        echo   ✅ ICO file created: %ICON_FILE%
    ) else (
        echo   ⚠️  Could not convert to ICO automatically
        echo   Please use an online converter: https://convertio.co/png-ico/
        echo   Or use: https://www.icoconverter.com/
        goto :manual_icon
    )
) else (
    echo   ⚠️  PNG file not found in Downloads
    echo   Please download the icon and save it manually
    goto :manual_icon
)

:update_shortcut
echo.
echo Updating desktop shortcut with custom icon...
(
echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
echo sLinkFile = "%SHORTCUT%"
echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
echo oLink.TargetPath = "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS\launch.bat"
echo oLink.WorkingDirectory = "%LOCALAPPDATA%\NeurQ\QS-DPDP-OS"
echo oLink.Description = "Quantum-Safe DPDP Compliance Operating System"
echo oLink.IconLocation = "%ICON_FILE%"
echo oLink.Save
echo WScript.Echo "Icon updated!"
) > "%TEMP%\update_icon.vbs"

cscript //nologo "%TEMP%\update_icon.vbs"

if %ERRORLEVEL% EQU 0 (
    echo   ✅ SUCCESS! Desktop shortcut updated with custom icon!
    echo.
    echo   Refresh your desktop (F5) to see the new icon!
    echo   The icon features:
    echo     - Google-style multi-color "QS" text
    echo     - "DPDP OS" at bottom
    echo     - Quantum-safe theme
    echo     - AI badge
) else (
    echo   ❌ Error updating shortcut
)

del "%TEMP%\update_icon.vbs" >nul 2>&1
goto :end

:manual_icon
echo.
echo Manual Icon Setup:
echo   1. Download icon from browser (PNG format)
echo   2. Convert PNG to ICO using: https://convertio.co/png-ico/
echo   3. Save as: QS-DPDP-OS-Icon.ico in this folder
echo   4. Run: update-shortcut-icon.bat
echo.

:end
pause
