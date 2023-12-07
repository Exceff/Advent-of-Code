Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d03_input'

$Sum = 0
$Numbers = [System.Collections.Generic.List[Array]]::new()
$Symbols = [System.Collections.Generic.List[Array]]::new()
for ($i = 0; $i -lt $InputData.Count; $i++) {
    $Numbers.Add(@(([Regex]'\d+').Matches($InputData[$i])))
    $Symbols.Add(@(([Regex]'[^\d\.]').Matches($InputData[$i])))
}
for ($i = 0; $i -lt $InputData.Count; $i++) {
    :Number foreach ($Number in $Numbers[$i]) {
        $MinIndex = $Number.Index - 1 # 1 before the start of the number
        $MaxIndex = $Number.Index + $Number.Length # 1 after the end of the number
        # iterate over the previous, current and next line unless we are in the first or last line
        for ($j = [Math]::Max(0, $i - 1); $j -le [Math]::Min(($i+1), $InputData.Count - 1); $j++) {
            foreach ($Symbol in $Symbols[$j]) {
                if ($Symbol.Index -ge $MinIndex -and $Symbol.Index -le $MaxIndex) {
                    $Sum += [int]$Number.Value
                    continue Number
                }
            }
        }
    }
}
$Sum
