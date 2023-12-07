Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d11_input'

Function Get-IncrementedPassword ($Password) {
    $PasswordCharArray = $Password.ToCharArray()
    $Count = 0
    do {
        $PasswordCharArray[($PasswordCharArray.Count - 1 - $Count)] = (($PasswordCharArray[($PasswordCharArray.Count - 1 - $Count)] - [char]'a' + 1) % 26) + [char]'a'
    } while (($PasswordCharArray.Count - 1 - ($Count + 1)) -ge 0 -and $PasswordCharArray[($PasswordCharArray.Count - 1 - ($Count++))] -eq [char]'a')
    return $PasswordCharArray -join ''
}

Function Test-Password ($Password) {
    if ($Password.Contains('i') -or $Password.Contains('o') -or $Password.Contains('l')) {
        return $false
    }
    # Following part is inspired by day 5, part 2
    $CharArray = $Password.ToCharArray()
    $HasRepetitionWithoutOverlapping = $false
    $HasStraightLetters = $false
    for ($i = 2; $i -lt $CharArray.Length; $i++) {
        if ($CharArray[$i] -ge [char]'c' -and $CharArray[$i - 2] -eq ([char]($CharArray[$i] - 2)) -and $CharArray[$i - 1] -eq ([char]($CharArray[$i])) - 1) {
            $HasStraightLetters = $true
        }
        for ($j = 1; $j -lt $i - 1; $j++) {
            if ($CharArray[$j-1] -eq $CharArray[$j] -and $CharArray[$i-1] -eq $CharArray[$i]) {
                $HasRepetitionWithoutOverlapping = $true
                #Write-Warning "$Password ($i, $j - $($CharArray[$j-1]) -eq $($CharArray[$i-1]) -and $($CharArray[$j]) -eq $($CharArray[$i]))"
            }
        }
    }
    if ($HasRepetitionWithoutOverlapping -and $HasStraightLetters) {
        return $true
    }
    return $false
}

$Password = $InputData
while (-not (Test-Password $Password)) {
    $Password = Get-IncrementedPassword $Password
}

$Password