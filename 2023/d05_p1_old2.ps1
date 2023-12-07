Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d05_input'

$Seeds = [System.Collections.Generic.Dictionary[uint, uint]]::new()
$Maps = [System.Collections.Generic.Dictionary[string, System.Collections.Generic.List[hashtable]]]::new()

$Mode = ''
foreach ($Line in ($InputData + '')) { # note the appended empty line to initiate the final calculation
    if ($Line -match '^seeds:.*$') {
        foreach ($Seed in ($Line -split ':\s+')[1] -split '\s+') {
            $Seeds.Add([uint]$Seed, [uint]$Seed)
        }
    } elseif ($Line -match '^(.*) map:') {
        $Mode = $Matches[1]
        $Maps.Add($Mode, [System.Collections.Generic.List[hashtable]]::new())
    } elseif ($Line -eq '') {
        if ($Mode -ne '') {
            # calculate the current mappings
            foreach ($Seed in $Seeds.Keys) {
                foreach ($Entry in $Maps[$Mode]) {
                    if ($Seeds[$Seed] -ge $Entry['SrcRangeStart'] -and $Seeds[$Seed] -lt ($Entry['SrcRangeStart'] + $Entry['RangeLength'])) {
                        $Seeds[$Seed] = $Entry['DstRangeStart'] + ($Seeds[$Seed] - $Entry['SrcRangeStart'])
                        break
                    }
                    # unmapped -> keep number
                }
            }
            $Mode = ''
        }
    } elseif ($Line -notmatch '\s*\d+\s+\d+\s+\d+') {
        throw 'invalid line'
    } elseif ($Mode -eq '') {
        throw 'mode not set'
    } else {
        # only data lines should be left
        [uint] $DstRangeStart, [uint] $SrcRangeStart, [uint] $RangeLength = $Line -split '\s+'
        $Maps[$Mode].Add(@{
            SrcRangeStart = $SrcRangeStart
            DstRangeStart = $DstRangeStart
            RangeLength = $RangeLength
        })
    }
}

($Seeds.Values | Measure-Object -Minimum).Minimum