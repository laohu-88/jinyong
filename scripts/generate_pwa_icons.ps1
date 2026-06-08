param(
  [string]$OutDir = (Join-Path (Split-Path -Parent $PSScriptRoot) 'icons')
)

Set-StrictMode -Version Latest
Add-Type -AssemblyName System.Drawing

function New-Font {
  param(
    [string[]]$Names,
    [float]$Size,
    [System.Drawing.FontStyle]$Style = [System.Drawing.FontStyle]::Regular
  )

  foreach ($name in $Names) {
    try {
      return [System.Drawing.Font]::new($name, $Size, $Style, [System.Drawing.GraphicsUnit]::Pixel)
    } catch {
      continue
    }
  }

  return [System.Drawing.Font]::new([System.Drawing.FontFamily]::GenericSerif, $Size, $Style, [System.Drawing.GraphicsUnit]::Pixel)
}

function Add-OutlinedText {
  param(
    [System.Drawing.Graphics]$Graphics,
    [string]$Text,
    [System.Drawing.Font]$Font,
    [System.Drawing.RectangleF]$Bounds,
    [System.Drawing.Brush]$Fill,
    [System.Drawing.Pen]$Outline,
    [float]$ShadowOffset = 0
  )

  $format = [System.Drawing.StringFormat]::new()
  $format.Alignment = [System.Drawing.StringAlignment]::Center
  $format.LineAlignment = [System.Drawing.StringAlignment]::Center

  if ($ShadowOffset -gt 0) {
    $shadowPath = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $shadowRect = [System.Drawing.RectangleF]::new(
      $Bounds.X + $ShadowOffset,
      $Bounds.Y + $ShadowOffset,
      $Bounds.Width,
      $Bounds.Height
    )
    $shadowPath.AddString($Text, $Font.FontFamily, [int]$Font.Style, $Font.Size, $shadowRect, $format)
    $Graphics.FillPath([System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(165, 0, 0, 0)), $shadowPath)
    $shadowPath.Dispose()
  }

  $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
  $path.AddString($Text, $Font.FontFamily, [int]$Font.Style, $Font.Size, $Bounds, $format)
  $Graphics.DrawPath($Outline, $path)
  $Graphics.FillPath($Fill, $path)
  $path.Dispose()
  $format.Dispose()
}

function New-JinyongIcon {
  $size = 1024
  $bitmap = [System.Drawing.Bitmap]::new($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

  $bounds = [System.Drawing.Rectangle]::new(0, 0, $size, $size)
  $bg = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
    $bounds,
    [System.Drawing.Color]::FromArgb(255, 35, 19, 11),
    [System.Drawing.Color]::FromArgb(255, 4, 8, 12),
    [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
  )
  $graphics.FillRectangle($bg, $bounds)
  $bg.Dispose()

  $moonBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(48, 244, 204, 126))
  $graphics.FillEllipse($moonBrush, 638, 76, 254, 254)
  $moonBrush.Dispose()

  $mountainPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(62, 232, 192, 118), 18)
  $mountainPen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
  foreach ($offset in 0, 86, 172) {
    $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $path.AddBezier(92, 690 + $offset, 230, 540 + $offset, 346, 560 + $offset, 494, 438 + $offset)
    $path.AddBezier(494, 438 + $offset, 626, 556 + $offset, 744, 506 + $offset, 932, 642 + $offset)
    $graphics.DrawPath($mountainPen, $path)
    $path.Dispose()
  }
  $mountainPen.Dispose()

  $scrollShadow = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(135, 0, 0, 0))
  $graphics.FillRectangle($scrollShadow, 132, 590, 760, 198)
  $scrollShadow.Dispose()

  $scrollBrush = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
    [System.Drawing.Rectangle]::new(116, 568, 792, 198),
    [System.Drawing.Color]::FromArgb(246, 226, 184, 109),
    [System.Drawing.Color]::FromArgb(246, 92, 38, 22),
    [System.Drawing.Drawing2D.LinearGradientMode]::Horizontal
  )
  $graphics.FillRectangle($scrollBrush, 116, 568, 792, 198)
  $scrollBrush.Dispose()

  $scrollPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(190, 255, 231, 159), 8)
  $graphics.DrawLine($scrollPen, 150, 612, 860, 612)
  $graphics.DrawLine($scrollPen, 150, 720, 860, 720)
  $scrollPen.Dispose()

  $swordPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(230, 235, 228, 205), 26)
  $swordPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $swordPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Triangle
  $graphics.DrawLine($swordPen, 224, 842, 754, 214)
  $swordPen.Dispose()

  $swordGlow = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(120, 255, 218, 118), 8)
  $graphics.DrawLine($swordGlow, 232, 832, 742, 226)
  $swordGlow.Dispose()

  $hiltPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(245, 188, 49, 30), 34)
  $hiltPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $hiltPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
  $graphics.DrawLine($hiltPen, 174, 744, 310, 856)
  $hiltPen.Dispose()

  $sealBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(230, 154, 21, 17))
  $graphics.FillEllipse($sealBrush, 676, 690, 184, 184)
  $sealBrush.Dispose()
  $sealPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(220, 255, 210, 144), 8)
  $graphics.DrawEllipse($sealPen, 676, 690, 184, 184)
  $sealPen.Dispose()

  $titleFont = New-Font -Names @('Microsoft YaHei UI', 'Microsoft YaHei', 'SimHei', 'SimSun') -Size 222 -Style ([System.Drawing.FontStyle]::Bold)
  $subtitleFont = New-Font -Names @('Microsoft YaHei UI', 'Microsoft YaHei', 'SimHei', 'SimSun') -Size 124 -Style ([System.Drawing.FontStyle]::Bold)
  $sealFont = New-Font -Names @('Microsoft YaHei UI', 'Microsoft YaHei', 'SimHei', 'SimSun') -Size 126 -Style ([System.Drawing.FontStyle]::Bold)
  $titleText = -join ([char]0x91D1, [char]0x5EB8)
  $subtitleText = -join ([char]0x7FA4, [char]0x4FA0, [char]0x4F20)
  $sealText = [string][char]0x4FA0

  $goldFill = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
    [System.Drawing.Rectangle]::new(0, 180, $size, 560),
    [System.Drawing.Color]::FromArgb(255, 255, 238, 153),
    [System.Drawing.Color]::FromArgb(255, 197, 128, 37),
    [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
  )
  $darkOutline = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(225, 55, 22, 7), 18)
  $redOutline = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(205, 88, 18, 8), 10)
  $sealFill = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(245, 255, 218, 156))

  $sealOutline = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(155, 96, 12, 9), 5)
  Add-OutlinedText -Graphics $graphics -Text $titleText -Font $titleFont -Bounds ([System.Drawing.RectangleF]::new(88, 154, 848, 268)) -Fill $goldFill -Outline $darkOutline -ShadowOffset 10
  Add-OutlinedText -Graphics $graphics -Text $subtitleText -Font $subtitleFont -Bounds ([System.Drawing.RectangleF]::new(126, 586, 690, 158)) -Fill $goldFill -Outline $redOutline -ShadowOffset 5
  Add-OutlinedText -Graphics $graphics -Text $sealText -Font $sealFont -Bounds ([System.Drawing.RectangleF]::new(690, 706, 154, 154)) -Fill $sealFill -Outline $sealOutline -ShadowOffset 0

  $goldFill.Dispose()
  $darkOutline.Dispose()
  $redOutline.Dispose()
  $sealOutline.Dispose()
  $sealFill.Dispose()
  $titleFont.Dispose()
  $subtitleFont.Dispose()
  $sealFont.Dispose()
  $graphics.Dispose()

  return $bitmap
}

function Save-ResizedPng {
  param(
    [System.Drawing.Bitmap]$Source,
    [string]$Path,
    [int]$Size
  )

  $target = [System.Drawing.Bitmap]::new($Size, $Size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $graphics = [System.Drawing.Graphics]::FromImage($target)
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $graphics.DrawImage($Source, 0, 0, $Size, $Size)
  $graphics.Dispose()
  $target.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
  $target.Dispose()
}

function Save-MaskablePng {
  param(
    [System.Drawing.Bitmap]$Source,
    [string]$Path,
    [int]$Size
  )

  $target = [System.Drawing.Bitmap]::new($Size, $Size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $graphics = [System.Drawing.Graphics]::FromImage($target)
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $graphics.Clear([System.Drawing.Color]::FromArgb(255, 20, 10, 6))

  $drawSize = [int]($Size * 0.84)
  $offset = [int](($Size - $drawSize) / 2)
  $graphics.DrawImage($Source, $offset, $offset, $drawSize, $drawSize)
  $graphics.Dispose()
  $target.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
  $target.Dispose()
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$icon = New-JinyongIcon
Save-ResizedPng -Source $icon -Path (Join-Path $OutDir 'icon-512.png') -Size 512
Save-MaskablePng -Source $icon -Path (Join-Path $OutDir 'maskable-512.png') -Size 512
Save-ResizedPng -Source $icon -Path (Join-Path $OutDir 'icon-192.png') -Size 192
Save-ResizedPng -Source $icon -Path (Join-Path $OutDir 'apple-touch-icon.png') -Size 180
Save-ResizedPng -Source $icon -Path (Join-Path $OutDir 'favicon-32.png') -Size 32
$icon.Dispose()

Write-Host "Generated PWA icons in $OutDir"
