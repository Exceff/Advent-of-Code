Set-StrictMode -Version latest
$ErrorActionPreference = 'Stop'

Function Get-Extrapolation([int[]] $Data) {
    [int[]] $Result = @()
    for ($i = 0; $i -lt ($Data.Count - 1); $i++) {
        $Diff = $Data[$i+1] - $Data[$i]
        $Result += $Diff
    }
    if (($Result | ForEach-Object { $_ -eq 0 }) -notcontains $false) {
        # all zeros
        return @(0; $Result)
    } else {
        return @(($Result[0] - @(Get-Extrapolation $Result)[0]); $Result)
    }
}

$InputData = Get-Content -Path '.\d09_input'

$Sum = 0
foreach ($Line in $InputData) {
    $Splitted = [int[]]@(($Line -split '\s+'))
    $GrandResult = Get-Extrapolation $Splitted
    $Sum += $Splitted[0] - $GrandResult[0]
}
$Sum
