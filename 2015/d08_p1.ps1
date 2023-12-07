Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d08_input'

$LengthDiscrepancy = 0
foreach ($Line in $InputData) {
    $LineTransformed = $Line.Trim('"') -replace '\\\\', '\' -replace '\\"', '"' -replace '\\x[0-9a-f]{2}', 'x'
    $LengthDiscrepancy += ($Line.Length - $LineTransformed.Length)
}

$LengthDiscrepancy