# PowerShell Script to Create QS-DPDP OS Icon
# Creates a custom icon with Google-style multi-color QS text

Add-Type -AssemblyName System.Drawing

# Create a 256x256 bitmap
$bitmap = New-Object System.Drawing.Bitmap(256, 256)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias

# Background gradient
$bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    [System.Drawing.Point]::new(0, 0),
    [System.Drawing.Point]::new(256, 256),
    [System.Drawing.Color]::FromArgb(30, 60, 114),  # #1e3c72
    [System.Drawing.Color]::FromArgb(126, 34, 206)  # #7e22ce
)
$graphics.FillRectangle($bgBrush, 0, 0, 256, 256)

# Quantum particles
$particleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(25, 255, 255, 255))
for ($i = 0; $i -lt 30; $i++) {
    $x = Get-Random -Minimum 0 -Maximum 256
    $y = Get-Random -Minimum 0 -Maximum 256
    $graphics.FillEllipse($particleBrush, $x, $y, 3, 3)
}

# Quantum ring
$ringPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(50, 255, 255, 255), 3)
$graphics.DrawEllipse($ringPen, 28, 28, 200, 200)

# QS Text - Q (Blue)
$fontQ = New-Object System.Drawing.Font("Arial", 80, [System.Drawing.FontStyle]::Bold)
$qBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 66, 133, 244))  # Google Blue
$graphics.DrawString("Q", $fontQ, $qBrush, 60, 80)

# QS Text - S (Multi-color gradient)
$fontS = New-Object System.Drawing.Font("Arial", 80, [System.Drawing.FontStyle]::Bold)
# Red
$sBrush1 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 234, 67, 53))  # Google Red
$graphics.DrawString("S", $fontS, $sBrush1, 140, 80)

# Yellow overlay
$sBrush2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(200, 251, 188, 4))  # Google Yellow
$graphics.DrawString("S", $fontS, $sBrush2, 140, 80)

# Green overlay
$sBrush3 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(150, 52, 168, 83))  # Google Green
$graphics.DrawString("S", $fontS, $sBrush3, 140, 80)

# DPDP OS text
$fontDPDP = New-Object System.Drawing.Font("Arial", 18, [System.Drawing.FontStyle]::Bold)
$textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$graphics.DrawString("DPDP OS", $fontDPDP, $textBrush, 75, 170)

# AI Badge
$aiBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    [System.Drawing.Point]::new(200, 10),
    [System.Drawing.Point]::new(246, 30),
    [System.Drawing.Color]::FromArgb(255, 102, 126, 234),
    [System.Drawing.Color]::FromArgb(255, 118, 75, 162)
)
$graphics.FillRoundedRectangle($aiBrush, 200, 10, 46, 20, 10)
$aiFont = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$graphics.DrawString("AI", $aiFont, $textBrush, 223, 12)

# Save as PNG first
$pngPath = Join-Path $PSScriptRoot "QS-DPDP-OS-Icon.png"
$bitmap.Save($pngPath, [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "PNG saved: $pngPath"

# Convert to ICO (simplified - creates multi-size ICO)
$iconSizes = @(16, 32, 48, 64, 128, 256)
$iconImages = New-Object System.Collections.ArrayList

foreach ($size in $iconSizes) {
    $resized = New-Object System.Drawing.Bitmap($bitmap, $size, $size)
    $iconImages.Add($resized) | Out-Null
}

# Create ICO file
$icoPath = Join-Path $PSScriptRoot "QS-DPDP-OS-Icon.ico"
try {
    # Simple ICO creation - save largest size as ICO
    $icoBitmap = New-Object System.Drawing.Bitmap($bitmap, 256, 256)
    $icoBitmap.Save($icoPath, [System.Drawing.Imaging.ImageFormat]::Icon)
    Write-Host "ICO saved: $icoPath"
} catch {
    # Fallback: Save as PNG and note conversion needed
    Write-Host "Note: Direct ICO creation failed. PNG saved instead."
    Write-Host "Please convert PNG to ICO using online tool:"
    Write-Host "  https://convertio.co/png-ico/"
}

# Cleanup
$graphics.Dispose()
$bitmap.Dispose()
$bgBrush.Dispose()
$ringPen.Dispose()
$fontQ.Dispose()
$fontS.Dispose()
$fontDPDP.Dispose()
$fontAI.Dispose()
$qBrush.Dispose()
$sBrush1.Dispose()
$sBrush2.Dispose()
$sBrush3.Dispose()
$textBrush.Dispose()
$aiBrush.Dispose()

Write-Host ""
Write-Host "✅ Icon creation complete!"
