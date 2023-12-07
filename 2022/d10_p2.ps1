Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d10_input'

$Output = @()
$Enum = $InputData.GetEnumerator()
$Enum.MoveNext()
$RegisterValue = 1
$Cycle = 0
$Line = [System.Text.StringBuilder]::new()
$Working = $false
while ($null -ne $Enum.Current) {
    $DrawPos = $Cycle % 40
    $Cycle++
    if($DrawPos -le ($RegisterValue + 1) -and $DrawPos -ge ($RegisterValue - 1)) {
        $Line.Append('#') | Out-Null
    } else {
        $Line.Append('.') | Out-Null
    }
    if ($DrawPos -eq 39) {
        $Output += $Line.ToString()
        $Line = [System.Text.StringBuilder]::new()
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

$Output