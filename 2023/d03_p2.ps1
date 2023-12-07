Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d03_input'

$Sum = 0
$Numbers = [System.Collections.Generic.List[Array]]::new()
$GearCandidates = [System.Collections.Generic.List[Array]]::new()
$GearCandidateNumbers = [System.Collections.Generic.Dictionary[Object,System.Collections.Generic.List[int]]]::new()
for ($i = 0; $i -lt $InputData.Count; $i++) {
    $Numbers.Add(@(([Regex]'\d+').Matches($InputData[$i])))
    $GearCandidates.Add(@(([Regex]'[\*]').Matches($InputData[$i])))
}
for ($i = 0; $i -lt $InputData.Count; $i++) {
    :Number foreach ($Number in $Numbers[$i]) {
        $MinIndex = $Number.Index - 1 # 1 before the start of the number
        $MaxIndex = $Number.Index + $Number.Length # 1 after the end of the number
        # iterate over the previous, current and next line unless we are in the first or last line
        for ($j = [Math]::Max(0, $i - 1); $j -le [Math]::Min(($i+1), $InputData.Count - 1); $j++) {
            foreach ($GearCandidate in $GearCandidates[$j]) {
                if ($GearCandidate.Index -ge $MinIndex -and $GearCandidate.Index -le $MaxIndex) {
                    if (-not $GearCandidateNumbers.ContainsKey($GearCandidate)) {
                        $GearCandidateNumbers.Add($GearCandidate, [System.Collections.Generic.List[int]]::new())
                    }
                    $GearCandidateNumbers[$GearCandidate].Add([int]$Number.Value)
                    #continue Number # it does work with this command, but only because the input does not have any number connected to more than one gear (which might be coincidence?)
                }
            }
        }
    }
}

foreach ($GearCandidate in $GearCandidateNumbers.GetEnumerator()) {
    if ($GearCandidate.Value.Count -eq 2) {
        $Sum += $GearCandidate.Value[0] * $GearCandidate.Value[1]
    }
}

$Sum