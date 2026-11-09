# Prints the colors of a picture and how much of it each covers, for window.luau to score.
# The picture is drawn into a small bitmap (each pixel the average of its area), then
# its pixels are grouped by the top 4 bits of each channel. One line per group, most
# pixels first: `rrggbb count`, the group's average color. Transparent pixels are left out.
param(
	[Parameter(Mandatory = $true)][string]$Path,
	[int]$Width = 96,
	[int]$Top = 128
)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$source = [System.Drawing.Image]::FromFile($Path)
try {
	$height = [Math]::Max(1, [int][Math]::Round($Width * $source.Height / $source.Width))
	$bitmap = New-Object System.Drawing.Bitmap $Width, $height, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
	$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
	$graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBilinear
	$graphics.DrawImage($source, 0, 0, $Width, $height)
	$graphics.Dispose()
} finally {
	$source.Dispose()
}

$rect = New-Object System.Drawing.Rectangle 0, 0, $Width, $height
$data = $bitmap.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadOnly, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$stride = $data.Stride
$bytes = New-Object byte[] ($stride * $height)
[System.Runtime.InteropServices.Marshal]::Copy($data.Scan0, $bytes, 0, $bytes.Length)
$bitmap.UnlockBits($data)
$bitmap.Dispose()

$count = New-Object int[] 4096
$sumR = New-Object int[] 4096
$sumG = New-Object int[] 4096
$sumB = New-Object int[] 4096
for ($y = 0; $y -lt $height; $y++) {
	$row = $y * $stride
	for ($x = 0; $x -lt $Width; $x++) {
		$i = $row + $x * 4
		if ($bytes[$i + 3] -lt 255) { continue }
		$b = $bytes[$i]; $g = $bytes[$i + 1]; $r = $bytes[$i + 2]
		$key = (($r -shr 4) -shl 8) -bor (($g -shr 4) -shl 4) -bor ($b -shr 4)
		$count[$key]++
		$sumR[$key] += $r; $sumG[$key] += $g; $sumB[$key] += $b
	}
}

$lines = for ($k = 0; $k -lt 4096; $k++) {
	$n = $count[$k]
	if ($n -gt 0) {
		[pscustomobject]@{
			Count = $n
			Text = '{0:x2}{1:x2}{2:x2} {3}' -f [int]($sumR[$k] / $n), [int]($sumG[$k] / $n), [int]($sumB[$k] / $n), $n
		}
	}
}
$lines | Sort-Object @{ Expression = 'Count'; Descending = $true }, @{ Expression = 'Text'; Descending = $false } |
	Select-Object -First $Top | ForEach-Object { $_.Text }
