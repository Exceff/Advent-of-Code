Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d06_input'

if ($InputData.Length -lt 4) {
    return -1
}

for ($i = 3; $i -lt $InputData.Length; $i++) {
    $Chars = $InputData[($i - 3)..$i]
    if (@($Chars | Select-Object -Unique).Count -eq 4) {
        return ($i + 1)
    }
}
return -1