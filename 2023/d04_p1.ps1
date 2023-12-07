Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d04_input'

$Sum = 0
foreach ($Line in $InputData) {
    $WinningNumbersStr, $PresentNumbersStr = (($Line -split ':\s+')[1]) -split '\s+\|\s+'
    [System.Collections.Generic.List[int]] $WinningNumbers = $WinningNumbersStr -split '\s+'
    [System.Collections.Generic.List[int]] $PresentNumbers = $PresentNumbersStr -split '\s+'
    $PresentWinningNumbers = @(Compare-Object $PresentNumbers $WinningNumbers -PassThru -IncludeEqual -ExcludeDifferent)
    if ($PresentWinningNumbers) {
        $CardValue = [Math]::Pow(2, ($PresentWinningNumbers.Count - 1))
        $Sum += $CardValue
    }
}
$Sum
