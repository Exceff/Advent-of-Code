Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d05_input'

$Seeds = [System.Collections.Generic.Dictionary[uint, uint]]::new()

$Map = $null
foreach ($Line in ($InputData + '')) { # note the appended empty line to initiate the final calculation
    if ($Line -match '^seeds:.*$') {
        foreach ($Seed in ($Line -split ':\s+')[1] -split '\s+') {
            $Seeds.Add([uint]$Seed, [uint]$Seed)
        }
    } elseif ($Line -match '^(.*) map:') {
        $Map = [System.Collections.Generic.List[hashtable]]::new()
    } elseif ($Line -eq '') {
        if ($null -ne $Map) {
            # calculate the current mappings
            foreach ($Seed in $Seeds.Keys) {
                foreach ($Entry in $Map) {
                    if ($Seeds[$Seed] -ge $Entry['SrcRangeStart'] -and $Seeds[$Seed] -lt ($Entry['SrcRangeStart'] + $Entry['RangeLength'])) {
                        $Seeds[$Seed] = $Entry['DstRangeStart'] + ($Seeds[$Seed] - $Entry['SrcRangeStart'])
                        break
                    }
                }
                # unmapped -> keep number
            }
            $Map = $Null
        }
    } elseif ($Line -notmatch '\s*\d+\s+\d+\s+\d+') {
        throw 'invalid line'
    } elseif ($null -eq $Map) {
        throw 'invalid sequence'
    } else {
        # only data lines should be left
        [uint] $DstRangeStart, [uint] $SrcRangeStart, [uint] $RangeLength = $Line -split '\s+'
        $Map.Add(@{
            SrcRangeStart = $SrcRangeStart
            DstRangeStart = $DstRangeStart
            RangeLength = $RangeLength
        })
    }
}

($Seeds.Values | Measure-Object -Minimum).Minimum