# Create Complete QS-DPDP OS Icon
# Google-like multi-color QS with DPDP OS text and AI theme

Add-Type -AssemblyName System.Drawing

$size = 256
$iconPath = Join-Path $PSScriptRoot "QS-DPDP-OS-Icon.ico"
$pngPath = Join-Path $PSScriptRoot "QS-DPDP-OS-Icon.png"

try {
    # Create bitmap
    $bitmap = New-Object System.Drawing.Bitmap($size, $size)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
    $graphics.Clear([System.Drawing.Color]::Transparent)
    
    # Gradient background (Quantum Safe theme - blue/purple)
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        [System.Drawing.Point]::new(0, 0),
        [System.Drawing.Point]::new($size, $size),
        [System.Drawing.Color]::FromArgb(102, 126, 234),
        [System.Drawing.Color]::FromArgb(118, 75, 162)
    )
    $graphics.FillRectangle($brush, 0, 0, $size, $size)
    
    # Draw "QS" text in multi-color (Google style)
    $qsFont = New-Object System.Drawing.Font("Arial", 80, [System.Drawing.FontStyle]::Bold)
    
    # Q in blue (Google Blue)
    $qBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(66, 133, 244))
    $graphics.DrawString("Q", $qsFont, $qBrush, 30, 60)
    
    # S in red (Google Red)
    $sBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(234, 67, 53))
    $graphics.DrawString("S", $qsFont, $sBrush, 110, 60)
    
    # DPDP OS text at bottom
    $osFont = New-Object System.Drawing.Font("Arial", 20, [System.Drawing.FontStyle]::Bold)
    $osBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $graphics.DrawString("DPDP OS", $osFont, $osBrush, 20, 190)
    
    # AI symbol (quantum/neural network dots)
    $dotBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    for ($i = 0; $i -lt 8; $i++) {
        $x = 180 + ($i % 4) * 15
        $y = 20 + [math]::Floor($i / 4) * 15
        $graphics.FillEllipse($dotBrush, $x, $y, 8, 8)
    }
    
    # Save as PNG first
    $bitmap.Save($pngPath, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Host "✅ PNG saved: $pngPath"
    
    # For ICO, try to save directly, or use PNG path
    try {
        # Try saving as ICO
        $icoBitmap = New-Object System.Drawing.Bitmap($bitmap, 256, 256)
        $icoBitmap.Save($iconPath)
        Write-Host "✅ ICO saved: $iconPath"
        $icoBitmap.Dispose()
    } catch {
        # Fallback: copy PNG (Windows can use PNG as icon)
        Copy-Item $pngPath $iconPath -Force -ErrorAction SilentlyContinue
        Write-Host "⚠️  Using PNG as icon (will work for shortcuts)"
    }
    
    # Cleanup
    $qBrush.Dispose()
    $sBrush.Dispose()
    $osBrush.Dispose()
    $dotBrush.Dispose()
    $brush.Dispose()
    $graphics.Dispose()
    $bitmap.Dispose()
    
    Write-Host ""
    Write-Host "✅ Icon creation complete!" -ForegroundColor Green
    
} catch {
    Write-Host "⚠️  Error creating icon: $_" -ForegroundColor Yellow
    Write-Host "Stack trace: $($_.Exception.StackTrace)" -ForegroundColor Yellow
    
    # Create a simple fallback icon if possible
    if (-not (Test-Path $iconPath)) {
        try {
            # Create simple colored square as fallback
            $simpleBitmap = New-Object System.Drawing.Bitmap(256, 256)
            $simpleGraphics = [System.Drawing.Graphics]::FromImage($simpleBitmap)
            $simpleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(66, 133, 244))
            $simpleGraphics.FillRectangle($simpleBrush, 0, 0, 256, 256)
            $simpleBitmap.Save($iconPath)
            $simpleGraphics.Dispose()
            $simpleBitmap.Dispose()
            Write-Host "✅ Created simple fallback icon" -ForegroundColor Green
        } catch {
            Write-Host "❌ Could not create fallback icon" -ForegroundColor Red
        }
    }
}
