Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d05_input'

$CratesStacksArr = @()
$CratesStacks = @{}
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
            if ($CratesStacksArr.Count - 1 -lt $i) {
                $CratesStacksArr += , @()
            }
            if ($Line[(4 * $i + 1)] -eq [char]' ') {
                continue
            }
            $CratesStacksArr[$i] += $Line[(4 * $i + 1)]
        }
        




        <#$CratesSplit = $Line -split '\s+'
        if ($null -eq $CratesStacksArr) {
            $CratesStacksArr = [array[]]::new($CratesSplit.Count)
            Write-Warning $CratesSplit.Count
        }
        for ($i = 0; $i -lt $CratesSplit.Count; $i++) {
            if ($CratesSplit[$i] -eq '') {
                continue
            }
            $CratesStacksArr[$i] += $CratesSplit[$i]
        }
        foreach ($Crate in $CratesSplit) {
            $CratesStacksArr += $Crate.TrimStart('[').TrimEnd(']')
        }#>
    }
    elseif ($Part -eq 2) {
        $Names = $Line.Trim(' ') -split '\s+'
        if ($Names.Count -ne $CratesStacksArr.Count) {
            throw "input error ($($Names.Count) | $($CratesStacksArr.Count))"
        }
        for ($i = 0; $i -lt $Names.Count; $i++) {
            $CratesStacks.Add($Names[$i], $CratesStacksArr[$i])
        }
    }
    elseif ($Part -eq 3) {
        $null, $Count, $null, $From, $null, $To = $Line -split ' '
        for ($i = 0; $i -lt $Count; $i++) {
            $Crate, $CratesStacks.$From = $CratesStacks.$From
            $CratesStacks.$To = $Crate, $CratesStacks.$To
        }
    }
}

$Sb = [System.Text.StringBuilder]::new()
foreach ($Name in $Names) {
    [void]$Sb.Append($CratesStacks.$Name[0])
}
$Sb.ToString()