Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d06_input'

# There surely is a mathematical solution for this problem. But ain't nobody got time for that.

$Time = [ulong] (($InputData[0] -split ':\s+')[1] -replace '\s+', '')
$RecordDistance = [ulong] (($InputData[1] -split ':\s+')[1] -replace '\s+', '')
$NumberOfWays = 0
for ($ButtonTime = 1; $ButtonTime -lt $Time; $ButtonTime++) { # 0 ms and complete race time make no sense
    $RemainingTime = $Time - $ButtonTime
    $Distance = $RemainingTime * $ButtonTime
    if ($Distance -gt $RecordDistance) {
        $NumberOfWays++
    }
}

$NumberOfWays