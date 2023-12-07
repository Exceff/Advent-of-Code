Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d06_input'

$Races = @()

$Times = ($InputData[0] -split ':\s+')[1] -split '\s+'
foreach ($Time in $Times) {
    $Races += @{
        Time = [uint] $Time
        RecordDistance = $null
        NumberOfWays = 0
    }
}

$RecordDistances = ($InputData[1] -split ':\s+')[1] -split '\s+'
for ($i = 0; $i -lt $RecordDistances.Count; $i++) {
    $Races[$i]['RecordDistance'] = [uint] $RecordDistances[$i]
}

foreach ($Race in $Races) {
    for ($ButtonTime = 1; $ButtonTime -lt $Race['Time']; $ButtonTime++) { # 0 ms and complete race time make no sense
        $RemainingTime = $Race['Time'] - $ButtonTime
        $Distance = $RemainingTime * $ButtonTime
        if ($Distance -gt $Race['RecordDistance']) {
            $Race['NumberOfWays']++
        }
    }
}

$Result = 1
foreach ($Race in $Races) {
    $Result *= $Race['NumberOfWays']
}
$Result