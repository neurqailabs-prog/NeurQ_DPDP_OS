# ========================================
# Professional Icon Creator for QS-DPDP OS
# Creates a high-quality ICO file with Google-style design
# ========================================

param(
    [string]$OutputPath = "QS-DPDP-OS-Icon.ico",
    [string]$PngPath = "QS-DPDP-OS-Icon.png"
)

Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = "Stop"

try {
    Write-Host "Creating professional icon..." -ForegroundColor Cyan
    
    # Create 256x256 bitmap (highest quality)
    $size = 256
    $bitmap = New-Object System.Drawing.Bitmap($size, $size)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    
    # Enable anti-aliasing for smooth rendering
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    
    # Clear with transparent background
    $graphics.Clear([System.Drawing.Color]::Transparent)
    
    # ========================================
    # Background: Quantum Safe Gradient
    # ========================================
    $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        [System.Drawing.Point]::new(0, 0),
        [System.Drawing.Point]::new($size, $size),
        [System.Drawing.Color]::FromArgb(102, 126, 234),  # Blue
        [System.Drawing.Color]::FromArgb(118, 75, 162)   # Purple
    )
    $graphics.FillRectangle($bgBrush, 0, 0, $size, $size)
    
    # ========================================
    # QS Text: Google-style Multi-color
    # ========================================
    $qsFont = New-Object System.Drawing.Font("Arial", 90, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
    
    # Q in Google Blue
    $qBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(66, 133, 244))
    $graphics.DrawString("Q", $qsFont, $qBrush, 25, 50)
    
    # S in Google Red
    $sBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(234, 67, 53))
    $graphics.DrawString("S", $qsFont, $sBrush, 115, 50)
    
    # ========================================
    # DPDP OS Text: At Bottom
    # ========================================
    $osFont = New-Object System.Drawing.Font("Arial", 22, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
    $osBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $graphics.DrawString("DPDP OS", $osFont, $osBrush, 15, 185)
    
    # ========================================
    # AI Theme: Quantum Dots (Neural Network)
    # ========================================
    $dotBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 255))
    $dotSize = 6
    
    # Create 8 dots in a neural network pattern
    $dots = @(
        @(190, 20), @(210, 20), @(230, 20), @(245, 20),
        @(190, 35), @(210, 35), @(230, 35), @(245, 35)
    )
    
    foreach ($dot in $dots) {
        $graphics.FillEllipse($dotBrush, $dot[0], $dot[1], $dotSize, $dotSize)
    }
    
    # ========================================
    # Save as PNG First
    # ========================================
    $bitmap.Save($PngPath, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Host "✅ PNG saved: $PngPath" -ForegroundColor Green
    
    # ========================================
    # Convert to ICO
    # ========================================
    # Create multiple sizes for ICO (16, 32, 48, 64, 128, 256)
    $icoSizes = @(16, 32, 48, 64, 128, 256)
    $icoBitmaps = New-Object System.Collections.ArrayList
    
    foreach ($icoSize in $icoSizes) {
        $icoBitmap = New-Object System.Drawing.Bitmap($bitmap, $icoSize, $icoSize)
        $icoBitmaps.Add($icoBitmap) | Out-Null
    }
    
    # Save largest size as ICO (Windows will use this)
    $icoBitmap256 = $icoBitmaps[$icoBitmaps.Count - 1]
    $icoBitmap256.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Icon)
    
    Write-Host "✅ ICO saved: $OutputPath" -ForegroundColor Green
    
    # Cleanup
    foreach ($icoBitmap in $icoBitmaps) {
        $icoBitmap.Dispose()
    }
    $qBrush.Dispose()
    $sBrush.Dispose()
    $osBrush.Dispose()
    $dotBrush.Dispose()
    $bgBrush.Dispose()
    $graphics.Dispose()
    $bitmap.Dispose()
    
    Write-Host ""
    Write-Host "✅ Icon creation complete!" -ForegroundColor Green
    Write-Host "   File: $OutputPath" -ForegroundColor White
    Write-Host "   Size: $size x $size pixels" -ForegroundColor White
    
} catch {
    Write-Host ""
    Write-Host "❌ Error creating icon: $_" -ForegroundColor Red
    Write-Host "Stack trace: $($_.Exception.StackTrace)" -ForegroundColor Yellow
    exit 1
}
