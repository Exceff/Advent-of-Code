Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d06_input'

$Lights = [array[]]::new(1000)
for ($X = 0; $X -lt 1000; $X++) {
    $Lights[$X] = [bool[]]::new(1000)
}

$LineCount = 0
foreach ($Line in $InputData) {
    $Line = $Line.Replace('turn on', 'turn_on').Replace('turn off', 'turn_off')
    $Command, $Pos1, $Through, $Pos2 = $Line -split ' '
    [int] $Pos1X, [int] $Pos1Y = $Pos1 -split ','
    [int] $Pos2X, [int] $Pos2Y = $Pos2 -split ','
    for ($X = $Pos1X; $X -le $Pos2X; $X++) {
        for ($Y = $Pos1Y; $Y -le $Pos2Y; $Y++) {
            if ($Command -eq 'turn_on') {
                $Lights[$X][$Y] = $true
            } elseif ($Command -eq 'turn_off') {
                $Lights[$X][$Y] = $false
            } else {
                $Lights[$X][$Y] = !$Lights[$X][$Y]
            }
        }
    }
    $LineCount++
    Write-Host "Line $LineCount of $($InputData.Count) processed"
}

$TotalLightsOn = 0
for ($X = 0; $X -lt 1000; $X++) {
    for ($Y = 0; $Y -lt 1000; $Y++) {
        $TotalLightsOn += $Lights[$X][$Y]
    }
}

$TotalLightsOn