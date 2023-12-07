Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d11_input'

[Collections.Generic.List[string]] $MonkeyNamesSorted = @()
$Monkeys = @{}
$CurrentMonkey = $null
foreach ($Line in $InputData) {
    if ($Line -like 'Monkey *:') {
        $null, $Name = $Line.TrimEnd(':') -split ' '
        $MonkeyNamesSorted.Add($Name)
        $Monkeys.Add($Name, @{})
        $CurrentMonkey = $Monkeys[$Name]
        $CurrentMonkey.Add('InspectionCounter', 0)
    } elseif ($Line -like '  Starting items: *') {
        [Collections.Generic.List[int]] $StartingItems = [int[]]@($Line.Substring(18) -split ', ')
        $CurrentMonkey.Add('Items', $StartingItems)
    } elseif ($Line -like '  Operation: new = old *') {
        $Operator, $Value = $Line.Substring(23) -split ' '
        $CurrentMonkey.Add('OpOperator', $Operator)
        $CurrentMonkey.Add('OpValue', $Value)
    } elseif ($Line -like '  Test: divisible by *') {
        [int] $Divisor = $Line.Substring(21)
        $CurrentMonkey.Add('TestDivisor', $Divisor)
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

for ($Round = 1; $Round -le 20; $Round++) {
    foreach ($Name in $MonkeyNamesSorted) {
        Write-Host "Monkey $($Name):"
        $CurrentMonkey = $Monkeys[$Name]
        for ($ItemNo = 0; $ItemNo -lt $CurrentMonkey['Items'].Count; $ItemNo++) {
            Write-Host "  Monkey inspects an item with a worry level of $($CurrentMonkey['Items'][$ItemNo])."
            $CurrentMonkey['InspectionCounter']++
            # monkey inspection - determine right term
            if ($CurrentMonkey['OpValue'] -eq 'old') {
                $RightTerm = $CurrentMonkey['Items'][$ItemNo]
                $OutputTerm = 'itself'
            } elseif ($CurrentMonkey['OpValue'] -match '^\d+$') {
                $RightTerm = [int]$CurrentMonkey['OpValue']
                $OutputTerm = $RightTerm
            } else {
                throw "invalid value: $($CurrentMonkey['OpValue'])"
            }
            # monkey inspection - determine operator and do inspection
            if ($CurrentMonkey['OpOperator'] -eq '+') {
                $CurrentMonkey['Items'][$ItemNo] += $RightTerm
                $OutputOperator = 'increases by'
            } elseif ($CurrentMonkey['OpOperator'] -eq '*') {
                $CurrentMonkey['Items'][$ItemNo] *= $RightTerm
                $OutputOperator = 'is multiplied by'
            } else {
                throw "invalid operator: $($CurrentMonkey['OpOperator'])"
            }
            Write-Host "    Worry level $OutputOperator $OutputTerm to $($CurrentMonkey['Items'][$ItemNo])."
            # after monkey inspection - decrease worry level
            $CurrentMonkey['Items'][$ItemNo] = [int]([Math]::Truncate($CurrentMonkey['Items'][$ItemNo] / 3))
            Write-Host "    Monkey gets bored with item. Worry level is divided by 3 to $($CurrentMonkey['Items'][$ItemNo])."
            # test - decide who to throw to
            if ($CurrentMonkey['Items'][$ItemNo] % $CurrentMonkey['TestDivisor'] -eq 0) {
                # true
                $TargetName = $CurrentMonkey['TrueTarget']
                $TestOutput = ''
            } else {
                # false
                $TargetName = $CurrentMonkey['FalseTarget']
                $TestOutput = 'not '
            }
            Write-Host "    Current worry level is $($TestOutput)divisible by $($CurrentMonkey['TestDivisor'])."
            # test - throw item
            if ($Monkeys.Keys -notcontains $TargetName) {
                throw "invalid monkey: $TargetName"
            }
            $TargetMonkey = $Monkeys[$TargetName]
            $TargetMonkey['Items'].Add($CurrentMonkey['Items'][$ItemNo])
            Write-Host "    Item with worry level $($CurrentMonkey['Items'][$ItemNo]) is thrown to monkey $($TargetName)."
        }
        $CurrentMonkey['Items'] = [Collections.Generic.List[int]]@()
    }
}

$SortedInspectionCounts = $Monkeys.Values.'InspectionCounter' | Sort-Object
return ($SortedInspectionCounts[-1] * $SortedInspectionCounts[-2])