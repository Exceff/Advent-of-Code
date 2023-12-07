Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d14_input'

$TotalTime = 2503

$HighestDistance = 0
foreach ($Line in $InputData) {
    $Name, $null, $null, [int] $FlySpeed, $null, $null, [int] $FlyTime, $null, $null, $null, $null, $null, $null, [int] $RestTime, $null = $Line -split ' '
    $FlyDistance = (([int][Math]::Truncate($TotalTime / ($FlyTime + $RestTime))*$FlyTime + [Math]::Min($FlyTime, (($TotalTime % ($FlyTime + $RestTime))))) * $FlySpeed)
    <#$TotalFlyingCycles = [int][Math]::Truncate($TotalTime / ($FlyTime+$RestTime))
    $RemainingSeconds= $TotalTime % ($FlyTime+$RestTime)
    $CycleFlyRange = $TotalFlyingCycles * $FlyTime * $FlySpeed
    $RestFlyRange = [Math]::Min($RemainingSeconds, $FlyTime) * $FlySpeed
    $FlyDistance = $CycleFlyRange + $RestFlyRange#>
    if ($HighestDistance -lt $FlyDistance) {
        $HighestDistance = $FlyDistance
    }
}

$HighestDistance