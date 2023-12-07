Set-StrictMode -Version latest

$Global:NumberOfRows = -1
$Global:FewestSteps = -1
$Global:FewestStepsForSquare = @{}
$Global:FewestStepsForSquareForCurrentTarget = @{}

Function Get-FewestSteps ($X, $Y, $TargetX, $TargetY, $PreviousSteps) {
    if ($PreviousSteps -contains "$x,$Y") {
        # been there, done that
        #Write-Host '1'
        return
    }
    $StepCount = $PreviousSteps.Count
    if ($StepCount -lt $Global:FewestSteps -and $StepCount -le $Global:FewestStepsForSquare[$Y][$X] -and $StepCount -lt $Global:FewestStepsForSquareForCurrentTarget[$Y][$X]) {
        $Global:FewestStepsForSquareForCurrentTarget[$Y][$X] = $StepCount
    } else {
        # been there faster, done that faster
        #Write-Host '2'
        return
    }
    if ($X -eq $TargetX -and $Y -eq $TargetY) {
        if ($StepCount -lt $Global:FewestSteps) {
            $Global:FewestSteps = $StepCount
            Write-Host "New record: $($Global:FewestSteps)"
        }
        return
    }
    $PreviousSteps += "$x,$Y"
    <#Write-Host "Current: $X,$Y - $($Map[$Y][$X])"
    if ($Y -gt 0) {
        Write-Host "Top: $X,$($Y-1) - $($Map[($Y-1)][$X])"
    }
    if ($Y -lt ($Map.Count-1)) {
        Write-Host "Bottom: $X,$($Y-1) - $($Map[($Y+1)][$X])"
    }
    if ($X -gt 0) {
        Write-Host "Left: $($X-1),$Y - $($Map[$Y][($X-1)])"
    }
    if ($X -lt ($Map[$Y].Count-1)) {
        Write-Host "Left: $($X+1),$Y - $($Map[$Y][($X+1)])"
    }#>
    if ($Y -gt 0 -and ([int]($Map[($Y-1)][$X])+1) -ge [int]($Map[$Y][$X])) {
        # top
        #Write-Host '3'
        Get-FewestSteps $X ($Y-1) $TargetX $TargetY $PreviousSteps
    }
    if ($Y -lt ($Map.Count-1) -and ([int]($Map[($Y+1)][$X])+1) -ge [int]($Map[$Y][$X])) {
        # bottom
        #Write-Host '4'
        Get-FewestSteps $X ($Y+1) $TargetX $TargetY $PreviousSteps
    }
    if ($X -gt 0 -and ([int]($Map[$Y][($X-1)])+1) -ge [int]($Map[$Y][$X])) {
        # left
        #Write-Host '5'
        Get-FewestSteps ($X-1) $Y $TargetX $TargetY $PreviousSteps
    }
    if ($X -lt ($Map[$Y].Count-1) -and ([int]($Map[$Y][($X+1)])+1) -ge [int]($Map[$Y][$X])) {
        # right
        #Write-Host '6'
        Get-FewestSteps ($X+1) $Y $TargetX $TargetY $PreviousSteps
    }
}

[string[]] $InputData = @(Get-Content -Path '.\d12_input')

$Map = @()
$PossibleStarts = @()
$StartX = -1
$StartY = -1
$EndX = -1
$EndY = -1
$Global:NumberOfRows = $InputData.Count
$NumberOfElements = $InputData.Count * $InputData[0].Length
$Global:FewestSteps = $NumberOfElements
for ($Row = 0; $Row -lt $InputData.Count; $Row++) {
    if ($InputData[$Row].Length -ne $InputData[0].Length) {
        throw 'input error: inconsistent length'
    }
    $FewestStepsForSquare.Add($Row, @{})
    $FewestStepsForSquareForCurrentTarget.Add($Row, @{})
    $NewRow = $InputData[$Row].ToCharArray()
    for ($Column = 0; $Column -lt $InputData[$Row].Length; $Column++) {
        $FewestStepsForSquare[$Row].Add($Column, $NumberOfElements)
        $FewestStepsForSquareForCurrentTarget[$Row].Add($Column, $NumberOfElements)
        if ($InputData[$Row][$Column] -ceq 'S') {
            if ($StartX -ne -1 -or $StartY -ne -1) {
                throw 'input error: duplicate start'
            }
            $StartX = $Column
            $StartY = $Row
            $NewRow[$Column] = [char]'a'
        } elseif ($InputData[$Row][$Column] -ceq 'E') {
            if ($EndX -ne -1 -or $EndY -ne -1) {
                throw 'input error: duplicate end'
            }
            $EndX = $Column
            $EndY = $Row
            $NewRow[$Column] = [char]'z'
        } elseif ($NewRow[$Column] -eq [char]'a') {
            if (($Row -gt 0 -and $InputData[($Row-1)][$Column] -eq 'b') -or ($Row -lt ($InputData.Count-1) -and $InputData[($Row+1)][$Column] -eq 'b') -or ($Column -gt 0 -and $InputData[$Row][($Column-1)] -eq 'b') -or ($Column -lt ($InputData[$Row].Length-1) -and $InputData[$Row][($Column+1)] -eq 'b')) {
                # candidates for the shortest path are all 'a's adjacent to 'b's
                $PossibleStarts += "$Column,$Row"
            }
        }
    }
    $Map += , $NewRow
}

if ($StartX -eq -1 -or $StartY -eq -1 -or $EndX -eq -1 -or $EndY -eq -1) {
    throw 'input error: no start/end'
}

$Count = 0
Write-Host "Checking original start $StartX,$StartY as a benchmark..."
Get-FewestSteps $EndX $EndY $StartX $StartY @()
foreach ($PossibleStart in $PossibleStarts) {
    $Count++
    [int] $PossibleStartX, [int] $PossibleStartY = $PossibleStart -split ','
    $Global:FewestStepsForSquareForCurrentTarget = @{}
    for ($Row = 0; $Row -lt $Map.Count; $Row++) {
        $Global:FewestStepsForSquareForCurrentTarget.Add($Row, @{})
        for ($Column = 0; $Column -lt $Map[$Row].Count; $Column++) {
            $Global:FewestStepsForSquareForCurrentTarget[$Row].Add($Column, $NumberOfElements)
        }
    }
    Write-Host "Checking $PossibleStartX,$PossibleStartY ($($Count) of $($PossibleStarts.Count))..."
    Get-FewestSteps $EndX $EndY $PossibleStartX $PossibleStartY @()
}

$Global:FewestSteps