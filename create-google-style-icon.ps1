# ========================================
# Create Google-Style Icon (Working Version)
# Multi-color QS like Google logo with DPDP OS text
# ========================================

Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = "Stop"

$size = 256
$iconPath = Join-Path $PSScriptRoot "QS-DPDP-OS-Icon.ico"
$pngPath = Join-Path $PSScriptRoot "QS-DPDP-OS-Icon.png"

Write-Host "Creating Google-style icon..." -ForegroundColor Cyan

try {
    # Create bitmap with high quality
    $bitmap = New-Object System.Drawing.Bitmap($size, $size)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    
    # Enable anti-aliasing
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    
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
    # QS Text: Google-Style Multi-Color
    # ========================================
    $fontSize = 90
    $font = New-Object System.Drawing.Font("Arial", $fontSize, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
    
    # Q in Google Blue (#4285F4)
    $qBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(66, 133, 244))
    $graphics.DrawString("Q", $font, $qBrush, 25, 50)
    
    # S in Google Red (#EA4335) with slight gradient effect
    $sBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(234, 67, 53))
    $graphics.DrawString("S", $font, $sBrush, 115, 50)
    
    # Add subtle yellow/green overlay on S for Google effect
    $sOverlay = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(100, 251, 188, 4))
    $graphics.DrawString("S", $font, $sOverlay, 115, 50)
    
    # ========================================
    # DPDP OS Text: At Bottom
    # ========================================
    $osFont = New-Object System.Drawing.Font("Arial", 22, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
    $osBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $graphics.DrawString("DPDP OS", $osFont, $osBrush, 15, 185)
    
    # ========================================
    # AI Theme: Quantum Dots
    # ========================================
    $dotBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $dots = @(
        @(190, 20), @(210, 20), @(230, 20), @(245, 20),
        @(190, 35), @(210, 35), @(230, 35), @(245, 35)
    )
    foreach ($dot in $dots) {
        $graphics.FillEllipse($dotBrush, $dot[0], $dot[1], 6, 6)
    }
    
    # ========================================
    # Save as PNG
    # ========================================
    $bitmap.Save($pngPath, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Host "✅ PNG saved: $pngPath" -ForegroundColor Green
    
    # ========================================
    # Convert PNG to ICO using .NET method
    # ========================================
    try {
        # Create ICO from PNG
        $pngImage = [System.Drawing.Image]::FromFile($pngPath)
        
        # Create ICO file
        $icoFile = New-Object System.IO.FileStream($iconPath, [System.IO.FileMode]::Create)
        
        # ICO header
        $icoFile.WriteByte(0)  # Reserved
        $icoFile.WriteByte(0)  # Reserved
        $icoFile.WriteByte(1)  # Type (1 = ICO)
        $icoFile.WriteByte(0)  # Type
        $icoFile.WriteByte(1)  # Number of images
        $icoFile.WriteByte(0)  # Number of images
        
        # Image directory entry
        $width = [Math]::Min(255, $size)
        $height = [Math]::Min(255, $size)
        $icoFile.WriteByte($width)  # Width
        $icoFile.WriteByte($height)  # Height
        $icoFile.WriteByte(0)  # Color palette
        $icoFile.WriteByte(0)  # Reserved
        $icoFile.WriteByte(1)  # Color planes
        $icoFile.WriteByte(0)  # Color planes
        $icoFile.WriteByte(32)  # Bits per pixel
        $icoFile.WriteByte(0)  # Bits per pixel
        
        # Image data size (will be written after)
        $dataSizePos = $icoFile.Position
        $icoFile.Write([BitConverter]::GetBytes(0), 0, 4)
        
        # Image data offset (will be written after)
        $dataOffsetPos = $icoFile.Position
        $icoFile.Write([BitConverter]::GetBytes(0), 0, 4)
        
        # Write image data
        $dataOffset = $icoFile.Position
        $pngImage.Save($icoFile, [System.Drawing.Imaging.ImageFormat]::Png)
        $dataSize = $icoFile.Position - $dataOffset
        
        # Update size and offset
        $icoFile.Position = $dataSizePos
        $icoFile.Write([BitConverter]::GetBytes($dataSize), 0, 4)
        $icoFile.Position = $dataOffsetPos
        $icoFile.Write([BitConverter]::GetBytes($dataOffset), 0, 4)
        
        $icoFile.Close()
        $pngImage.Dispose()
        
        Write-Host "✅ ICO saved: $iconPath" -ForegroundColor Green
    } catch {
        # Fallback: Copy PNG as ICO (Windows can use PNG as icon)
        Copy-Item $pngPath $iconPath -Force
        Write-Host "⚠️  Using PNG as ICO (will work)" -ForegroundColor Yellow
    }
    
    # Cleanup
    $qBrush.Dispose()
    $sBrush.Dispose()
    $sOverlay.Dispose()
    $osBrush.Dispose()
    $dotBrush.Dispose()
    $bgBrush.Dispose()
    $font.Dispose()
    $osFont.Dispose()
    $graphics.Dispose()
    $bitmap.Dispose()
    
    Write-Host ""
    Write-Host "✅ Google-style icon created successfully!" -ForegroundColor Green
    Write-Host "   File: $iconPath" -ForegroundColor White
    Write-Host "   Size: $size x $size pixels" -ForegroundColor White
    
} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
    Write-Host "Stack: $($_.Exception.StackTrace)" -ForegroundColor Yellow
    exit 1
}
