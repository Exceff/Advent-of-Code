Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d06_input'

if ($InputData.Length -lt 14) {
    return -1
}

for ($i = 13; $i -lt $InputData.Length; $i++) {
    $Chars = $InputData[($i - 13)..$i]
    if (@($Chars | Select-Object -Unique).Count -eq 14) {
        return ($i + 1)
    }
}
return -1