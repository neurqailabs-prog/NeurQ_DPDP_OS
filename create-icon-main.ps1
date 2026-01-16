# Create Main QS-DPDP OS Icon
# Google-like multi-color QS with DPDP OS text

$size = 256
$iconPath = "QS-DPDP-OS-Icon.ico"

try {
    Add-Type -AssemblyName System.Drawing
    
    # Create bitmap
    $bitmap = New-Object System.Drawing.Bitmap($size, $size)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
    
    # Gradient background (Quantum Safe theme - blue/purple)
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        [System.Drawing.Point]::new(0, 0),
        [System.Drawing.Point]::new($size, $size),
        [System.Drawing.Color]::FromArgb(102, 126, 234),
        [System.Drawing.Color]::FromArgb(118, 75, 162)
    )
    $graphics.FillRectangle($brush, 0, 0, $size, $size)
    
    # Draw "QS" text in multi-color (Google style)
    $qsFont = New-Object System.Drawing.Font("Segoe UI", 72, [System.Drawing.FontStyle]::Bold)
    
    # Q in blue
    $qBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(66, 133, 244))
    $graphics.DrawString("Q", $qsFont, $qBrush, 30, 60)
    
    # S in red
    $sBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(234, 67, 53))
    $graphics.DrawString("S", $qsFont, $sBrush, 110, 60)
    
    # DPDP OS text at bottom
    $osFont = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
    $osBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $graphics.DrawString("DPDP OS", $osFont, $osBrush, 20, 190)
    
    # AI symbol (small quantum/neural network dots)
    $dotBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    for ($i = 0; $i -lt 8; $i++) {
        $x = 180 + ($i % 4) * 15
        $y = 20 + [math]::Floor($i / 4) * 15
        $graphics.FillEllipse($dotBrush, $x, $y, 8, 8)
    }
    
    # Save as PNG first
    $pngPath = "QS-DPDP-OS-Icon.png"
    $bitmap.Save($pngPath, [System.Drawing.Imaging.ImageFormat]::Png)
    
    # Convert to ICO (simplified - using PNG as icon)
    Copy-Item $pngPath $iconPath -Force
    
    Write-Host "✅ Icon created: $iconPath"
    
    $qBrush.Dispose()
    $sBrush.Dispose()
    $osBrush.Dispose()
    $dotBrush.Dispose()
    $graphics.Dispose()
    $bitmap.Dispose()
    $brush.Dispose()
    
} catch {
    Write-Host "⚠️  Error creating icon: $_" -ForegroundColor Yellow
    # Create a simple fallback
    if (-not (Test-Path $iconPath)) {
        Copy-Item "QS-DPDP-OS-Icon.png" $iconPath -ErrorAction SilentlyContinue
    }
}
