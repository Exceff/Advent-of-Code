Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d02_input'

$TotalRibbonLength = 0
foreach ($Line in $InputData) {
    [int] $Length, [int] $Width, [int] $Height = $Line -split 'x'
    $ShortestSide, $SecondShortestSide = (@($Length, $Width, $Height) | Sort-Object)[0..1]
    $Volume = $Length * $Width * $Height
    $TotalRibbonLength += 2 * $ShortestSide + 2 * $SecondShortestSide + $Volume
}

$TotalRibbonLength