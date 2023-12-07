Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d02_input'

$TotalPaperArea = 0
foreach ($Line in $InputData) {
    [int] $Length, [int] $Width, [int] $Height = $Line -split 'x'
    $Side1Area = $Length * $Width
    $Side2Area = $Width * $Height
    $Side3Area = $Height * $Length
    $SmallestSideArea = (@($Side1Area, $Side2Area, $Side3Area) | Measure-Object -Minimum).Minimum
    $TotalPaperArea += 2 * $Side1Area + 2* $Side2Area + 2* $Side3Area + $SmallestSideArea
}

$TotalPaperArea