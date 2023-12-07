Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d08_input'

$LengthDiscrepancy = 0
foreach ($Line in $InputData) {
    $LineTransformed = "`"$($Line -replace '\\', '\\' -replace '\"', '\"')`""
    $LengthDiscrepancy += ($LineTransformed.Length - $Line.Length)
}

$LengthDiscrepancy