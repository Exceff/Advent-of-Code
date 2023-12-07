Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d05_input'

$Seeds = [System.Collections.Generic.List[hashtable]]::new()

$Map = $null
foreach ($Line in ($InputData + '')) { # note the appended empty line to initiate the final calculation
    if ($Line -match '^seeds:.*$') {
        $Entries = ($Line -split ':\s+')[1] -split '\s+'
        for ($i = 0; $i -lt ($Entries.Count - 1); $i += 2) { # every other element
            $Seeds.Add(@{
                RangeStart = [uint] $Entries[$i]
                RangeEnd = [uint] $Entries[$i] + [uint] $Entries[($i + 1)] - 1 # range is inclusive
            })
        }
    } elseif ($Line -match '^(.*) map:') {
        $Map = [System.Collections.Generic.List[hashtable]]::new()
    } elseif ($Line -eq '') {
        if ($null -ne $Map) {
            # empty line after data lines; calculate the current mappings
            $NewSeeds = [System.Collections.Generic.List[hashtable]]::new()
            :Seeds while ($Seeds.Count -gt 0) {
                $Seed = $Seeds[0]
                $Seeds.RemoveAt(0)
                $SeedStart = $Seed['RangeStart']
                $SeedEnd = $Seed['RangeEnd']
                foreach ($Entry in $Map) {
                    $EntrySrcStart = $Entry['SrcRangeStart']
                    $EntryDstStart = $Entry['DstRangeStart']
                    $EntryLength = $Entry['RangeLength']
                    $EntrySrcEnd = $EntrySrcStart + $EntryLength
                    $EntryDstEnd = $EntryDstStart + $EntryLength
                    if ($SeedStart -le $EntrySrcEnd -and $EntrySrcStart -le $SeedEnd) {
                        # seed and entry ranges overlap
                        $StartOffset = $SeedStart - $EntrySrcStart
                        $EndOffset = $SeedEnd - $EntrySrcEnd
                        # the following min and max expressions are used to handle cases where the seed range starts before or ends after the entry range
                        $NewSeed = @{
                            RangeStart = $EntryDstStart + [Math]::Max($StartOffset, 0)
                            RangeEnd = $EntryDstEnd + [Math]::Min($EndOffset, 0)
                        }
                        $NewSeeds.Add($NewSeed)
                        if ($StartOffset -lt 0) {
                            # the seed range starts before the entry range; add remaining seed range back to the seed list
                            $RemainingBeforeSeed = @{
                                RangeStart = $SeedStart
                                RangeEnd = $EntrySrcStart - 1
                            }
                            $Seeds.Add($RemainingBeforeSeed) # add back to seeds to be checked again in case it is mapped by another entry
                        }
                        if ($EndOffset -gt 0) {
                            # the seed range ends after the entry range; add remaining seed range back to the seed list
                            $RemainingAfterSeed = @{
                                RangeStart = $EntrySrcEnd + 1
                                RangeEnd = $SeedEnd
                            }
                            $Seeds.Add($RemainingAfterSeed) # add back to seeds to be checked again in case it is mapped by another entry
                        }
                        continue Seeds # so that the code after the foreach is not executed
                    }
                }
                # unmapped -> keep number
                $NewSeeds.Add($Seed)
            }
            $Seeds = $NewSeeds
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

($Seeds | Measure-Object { $_.RangeStart } -Minimum).Minimum