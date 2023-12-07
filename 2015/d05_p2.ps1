Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d05_input'

$NiceCount = 0
foreach ($Line in $InputData) {
    $CharArray = $Line.ToCharArray()
    $HasRepetitionWithoutOverlapping = $false
    $HasRepetitionWithSingleLetterDistance = $false
    for ($i = 2; $i -lt $CharArray.Length; $i++) {
        if ($CharArray[$i - 2] -eq $CharArray[$i]) {
            $HasRepetitionWithSingleLetterDistance = $true
        }
        for ($j = 1; $j -lt $i - 1; $j++) {
            if ($CharArray[$j-1] -eq $CharArray[$i-1] -and $CharArray[$j] -eq $CharArray[$i]) {
                $HasRepetitionWithoutOverlapping = $true
            }
        }
    }
    if ($HasRepetitionWithoutOverlapping -and $HasRepetitionWithSingleLetterDistance) {
        $NiceCount++
    }
}

$NiceCount