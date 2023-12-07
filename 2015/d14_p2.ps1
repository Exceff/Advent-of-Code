Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d14_input'

$TotalTime = 2503

$Reindeer = @()
foreach ($Line in $InputData) {
    $Name, $null, $null, [int] $FlySpeed, $null, $null, [int] $FlyTime, $null, $null, $null, $null, $null, $null, [int] $RestTime, $null = $Line -split ' '
    $Reindeer += @{Name = $Name; FlySpeed = $FlySpeed; FlyTime = $FlyTime; RestTime = $RestTime; RoundDistance = 0; Score = 0}
}

for ($Time = 1; $Time -le $TotalTime; $Time++) {
    foreach ($CurrentReindeer in $Reindeer) {
        $CurrentReindeer.RoundDistance = (([int][Math]::Truncate($Time / ($CurrentReindeer.FlyTime + $CurrentReindeer.RestTime))*$CurrentReindeer.FlyTime + [Math]::Min($CurrentReindeer.FlyTime, (($Time % ($CurrentReindeer.FlyTime + $CurrentReindeer.RestTime))))) * $CurrentReindeer.FlySpeed)
    }
    $SortedReindeer = ($Reindeer | Sort-Object {$_.RoundDistance} -Descending)
    $SortedReindeer | Where-Object {$_.RoundDistance -eq $SortedReindeer[0].RoundDistance} | ForEach-Object { $_.Score++ }
}

($Reindeer | Sort-Object {$_.Score} -Descending)[0].Score