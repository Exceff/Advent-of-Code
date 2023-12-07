Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d11_input'

[Collections.Generic.List[string]] $MonkeyNamesSorted = @()
$Monkeys = @{}
$CurrentMonkey = $null
$CommonDenominator = 1
foreach ($Line in $InputData) {
    if ($Line -like 'Monkey *:') {
        $null, $Name = $Line.TrimEnd(':') -split ' '
        $MonkeyNamesSorted.Add($Name)
        $Monkeys.Add($Name, @{})
        $CurrentMonkey = $Monkeys[$Name]
        $CurrentMonkey.Add('InspectionCounter', 0)
    } elseif ($Line -like '  Starting items: *') {
        [Collections.Generic.List[uint64]] $StartingItems = [uint64[]]@($Line.Substring(18) -split ', ')
        $CurrentMonkey.Add('Items', $StartingItems)
    } elseif ($Line -like '  Operation: new = old *') {
        $Operator, $Value = $Line.Substring(23) -split ' '
        $CurrentMonkey.Add('OpOperator', $Operator)
        $CurrentMonkey.Add('OpValue', $Value)
    } elseif ($Line -like '  Test: divisible by *') {
        [int] $Divisor = $Line.Substring(21)
        $CurrentMonkey.Add('TestDivisor', $Divisor)
        $CommonDenominator *= $Divisor
    } elseif ($Line -like '    If true: throw to monkey *') {
        $TrueTarget = $Line.Substring(29)
        $CurrentMonkey.Add('TrueTarget', $TrueTarget)
    } elseif ($Line -like '    If false: throw to monkey *') {
        $FalseTarget = $Line.Substring(30)
        $CurrentMonkey.Add('FalseTarget', $FalseTarget)
    } elseif ($Line -ne '') {
        throw "invalid line: $Line"
    }
}

for ($Round = 1; $Round -le 10000; $Round++) {
    foreach ($Name in $MonkeyNamesSorted) {
        $CurrentMonkey = $Monkeys[$Name]
        for ($ItemNo = 0; $ItemNo -lt $CurrentMonkey['Items'].Count; $ItemNo++) {
            $CurrentMonkey['InspectionCounter']++
            # monkey inspection - determine right term
            if ($CurrentMonkey['OpValue'] -eq 'old') {
                $RightTerm = $CurrentMonkey['Items'][$ItemNo]
            } elseif ($CurrentMonkey['OpValue'] -match '^\d+$') {
                $RightTerm = [int]$CurrentMonkey['OpValue']
            } else {
                throw "invalid value: $($CurrentMonkey['OpValue'])"
            }
            # monkey inspection - determine operator and do inspection
            if ($CurrentMonkey['OpOperator'] -eq '+') {
                $CurrentMonkey['Items'][$ItemNo] += $RightTerm
            } elseif ($CurrentMonkey['OpOperator'] -eq '*') {
                $CurrentMonkey['Items'][$ItemNo] *= $RightTerm
            } else {
                throw "invalid operator: $($CurrentMonkey['OpOperator'])"
            }
            # after monkey inspection - manage worry level by removing multiples of common denominator
            $CurrentMonkey['Items'][$ItemNo] %= $CommonDenominator
            # test - decide who to throw to
            if ($CurrentMonkey['Items'][$ItemNo] % $CurrentMonkey['TestDivisor'] -eq 0) {
                # true
                $TargetName = $CurrentMonkey['TrueTarget']
            } else {
                # false
                $TargetName = $CurrentMonkey['FalseTarget']
            }
            # test - throw item
            if ($Monkeys.Keys -notcontains $TargetName) {
                throw "invalid monkey: $TargetName"
            }
            $TargetMonkey = $Monkeys[$TargetName]
            $TargetMonkey['Items'].Add($CurrentMonkey['Items'][$ItemNo])
        }
        $CurrentMonkey['Items'] = [Collections.Generic.List[uint64]]@()
    }
}

$SortedInspectionCounts = $Monkeys.Values.'InspectionCounter' | Sort-Object
return ($SortedInspectionCounts[-1] * $SortedInspectionCounts[-2])