Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d05_input'

[Collections.Generic.List[string][]] $CrateStackArr = @()
$CrateStacks = @{}
$Names = $null
$Part = 1
foreach ($Line in $InputData) {
    if ($Part -eq 1 -and -not $Line.Contains('[')) {
        $Part = 2
    }
    if ($Part -eq 2 -and $Line -eq '') {
        $Part = 3
        continue
    }
    if ($Part -eq 1) {
        for ($i = 0; (4 * $i + 1) -lt $Line.Length; $i++) {
            if ($CrateStackArr.Count - 1 -lt $i) {
                $CrateStackArr += , [Collections.Generic.List[string]]::new()
            }
            if ($Line[(4 * $i + 1)] -eq [char]' ') {
                continue
            }
            $CrateStackArr[$i].Add($Line[(4 * $i + 1)])
        }
    }
    elseif ($Part -eq 2) {
        $Names = $Line.Trim(' ') -split '\s+'
        if ($Names.Count -ne $CrateStackArr.Count) {
            throw "input error ($($Names.Count) | $($CrateStackArr.Count))"
        }
        for ($i = 0; $i -lt $Names.Count; $i++) {
            $CrateStacks.Add($Names[$i], $CrateStackArr[$i])
        }
    }
    elseif ($Part -eq 3) {
        $null, [int] $Count, $null, $From, $null, $To = $Line -split ' '
        if ($CrateStacks.$From.Count -lt $Count) {
            throw "no crate at $From"
        }
        [Collections.Generic.List[string]] $Crates = $CrateStacks.$From[0..($Count - 1)]
        $CrateStacks.$From.RemoveRange(0, $Count)
        $CrateStacks.$To.InsertRange(0, $Crates)
    }
}

$Sb = [System.Text.StringBuilder]::new()
foreach ($Name in $Names) {
    [void]$Sb.Append($CrateStacks.$Name[0])
}
$Sb.ToString()