Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d05_input'

$NiceCount = 0
foreach ($Line in $InputData) {
    if ($Line.Contains('ab') -or $Line.Contains('cd') -or $Line.Contains('pq') -or $Line.Contains('xy')) {
        continue
    }
    $VowelCount = 0
    $HasDouble = $false
    $PreviousChar = $null
    foreach ($Char in $Line.ToCharArray()) {
        if ($Char -in @([char]'a', [char]'e', [char]'i', [char]'o', [char]'u')) {
            $VowelCount++
        }
        if ($Char -eq $PreviousChar) {
            $HasDouble = $true
        }
        $PreviousChar = $Char
    }
    if ($VowelCount -ge 3 -and $HasDouble) {
        $NiceCount++
    }
}

$NiceCount