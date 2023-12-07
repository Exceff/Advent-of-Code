Set-StrictMode -Version latest

$Global:FewestSteps = -1
$Global:FewestStepsForSquare = @{}

Function Get-FewestSteps ($X, $Y, $PreviousSteps) {
    if ($PreviousSteps -contains "$x,$Y") {
        # been there, done that
        return
    }
    if ($PreviousSteps.Count -lt $Global:FewestSteps -and $PreviousSteps.Count -lt $Global:FewestStepsForSquare[$Y][$X]) {
        $Global:FewestStepsForSquare[$Y][$X] = $PreviousSteps.Count
    } else {
        # been there faster, done that faster
        return
    }
    if ($X -eq $EndX -and $Y -eq $EndY) {
        if ($PreviousSteps.Count -lt $Global:FewestSteps) {
            $Global:FewestSteps = $PreviousSteps.Count
            Write-Host "New record: $($Global:FewestSteps)"
        }
        return
    }
    $PreviousSteps += "$x,$Y"
    if ($Y -gt 0 -and [int]($Map[($Y-1)][$X]) -le ([int]($Map[$Y][$X])+1)) {
        # top
        Get-FewestSteps $X ($Y-1) $PreviousSteps
    }
    if ($Y -lt ($Map.Count-1) -and [int]($Map[($Y+1)][$X]) -le ([int]($Map[$Y][$X])+1)) {
        # bottom
        Get-FewestSteps $X ($Y+1) $PreviousSteps
    }
    if ($X -gt 0 -and [int]($Map[$Y][($X-1)]) -le ([int]($Map[$Y][$X])+1)) {
        # left
        Get-FewestSteps ($X-1) $Y $PreviousSteps
    }
    if ($X -lt ($Map[$Y].Count-1) -and [int]($Map[$Y][($X+1)]) -le ([int]($Map[$Y][$X])+1)) {
        # right
        Get-FewestSteps ($X+1) $Y $PreviousSteps
    }
}

[string[]] $InputData = @(Get-Content -Path '.\d12_input')

$Map = @()
$StartX = -1
$StartY = -1
$EndX = -1
$EndY = -1
$NumberOfElements = $InputData.Count * $InputData[0].Length
$Global:FewestSteps = $NumberOfElements
for ($Row = 0; $Row -lt $InputData.Count; $Row++) {
    if ($InputData[$Row].Length -ne $InputData[0].Length) {
        throw 'input error: inconsistent length'
    }
    $FewestStepsForSquare.Add($Row, @{})
    $NewRow = $InputData[$Row].ToCharArray()
    for ($Column = 0; $Column -lt $InputData[$Row].Length; $Column++) {
        $FewestStepsForSquare[$Row].Add($Column, $NumberOfElements)
        if ($InputData[$Row][$Column] -ceq 'S') {
            if ($StartX -ne -1 -or $StartY -ne -1) {
                throw 'input error: duplicate start'
            }
            $StartX = $Column
            $StartY = $Row
            $NewRow[$Column] = 'a'
        } elseif ($InputData[$Row][$Column] -ceq 'E') {
            if ($EndX -ne -1 -or $EndY -ne -1) {
                throw 'input error: duplicate end'
            }
            $EndX = $Column
            $EndY = $Row
            $NewRow[$Column] = 'z'
        }
    }
    $Map += , $NewRow
}

if ($StartX -eq -1 -or $StartY -eq -1 -or $EndX -eq -1 -or $EndY -eq -1) {
    throw 'input error: no start/end'
}

Get-FewestSteps $StartX $StartY @()

$Global:FewestSteps