Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d10_input'

Function Get-LookAndSaySequence ($Sequence) {
    $SeriesChar = -1
    $SeriesCount = 0
    $Sb = [System.Text.StringBuilder]::new()
    $CharArray = $Sequence.ToCharArray()
    for ($i = 0; $i -lt $CharArray.Count; $i++) {
        $Char = $CharArray[$i]
        if ($Char -ne $SeriesChar) {
            if ($SeriesChar -ne -1) {
                [void]$Sb.Append("$($SeriesCount)$($SeriesChar)")
            }
            $SeriesChar = $Char
            $SeriesCount = 0
        }
        $SeriesCount++
    }
    if ($SeriesChar -ne -1) {
        [void]$Sb.Append("$($SeriesCount)$($SeriesChar)")
    }

    return $Sb.ToString()
}

$Sequence = $InputData
for ($i = 0; $i -lt 50; $i++) {
    $Sequence = Get-LookAndSaySequence $Sequence
}

$Sequence.Length