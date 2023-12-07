Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d04_input'

# this takes ages and there is a simpler approach, but it works eventually

Function Get-WinningCards([int] $LineNo) {
    $Result = 1 # the card we have
    if ($LineNo -ge $InputData.Count) {
        return $Result
    }
    $Line = $InputData[$LineNo]
    $WinningNumbersStr, $PresentNumbersStr = (($Line -split ':\s+')[1]) -split '\s+\|\s+'
    [System.Collections.Generic.List[int]] $WinningNumbers = $WinningNumbersStr -split '\s+'
    [System.Collections.Generic.List[int]] $PresentNumbers = $PresentNumbersStr -split '\s+'
    $PresentWinningNumbers = @(Compare-Object $PresentNumbers $WinningNumbers -PassThru -IncludeEqual -ExcludeDifferent)
    for ($i = 1; $i -le $PresentWinningNumbers.Count; $i++) {
        $Result += Get-WinningCards ($LineNo + $i)
    }
    return $Result
}

$Sum = 0
for ($LineNo = 0; $LineNo -lt $InputData.Count; $LineNo++) {
    $Sum += Get-WinningCards $LineNo
}
$Sum
