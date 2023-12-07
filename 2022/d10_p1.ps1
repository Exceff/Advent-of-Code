Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d10_input'

$Sum = 0
$Enum = $InputData.GetEnumerator()
$Enum.MoveNext()
$RegisterValue = 1
$Cycle = 0
$Working = $false
while ($null -ne $Enum.Current) {
    $Cycle++
    if (($Cycle - 20) % 40 -eq 0) {
        Write-Host "$($Cycle): $($Cycle * $RegisterValue)"
        $Sum += $Cycle * $RegisterValue
    }
    if ($Enum.Current -eq 'noop') {
        $Enum.MoveNext() | Out-Null
        continue
    }
    $Command, [int] $Value = $Enum.Current -split ' '
    if ($Command -ne 'addx') {
        throw 'invalid command'
    }
    if ($Working) {
        $RegisterValue += $Value
        $Working = $false
        $Enum.MoveNext() | Out-Null
        continue
    }
    $Working = $true
}

$Sum