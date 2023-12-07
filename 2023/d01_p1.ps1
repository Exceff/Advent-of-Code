Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d01_input'

$Sum = 0
foreach ($Line in $InputData) {
    $Values = ([Regex]'\d').Matches($Line).Value
    if (-not $Values) {
        throw 'no digits found for line ' + $Line
    }
    $LineValue = [int][string]$Values[0] * 10 + [int][string]$Values[-1]
    $Sum += $LineValue
}
$Sum
