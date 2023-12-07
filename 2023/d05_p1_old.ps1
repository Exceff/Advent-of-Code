Set-StrictMode -Version latest

Function Get-DestinationBySource([uint] $Source, [System.Collections.Generic.List[hashtable]] $List) {
    foreach ($Entry in $List) {
        if ($Source -ge $Entry['SrcRangeStart'] -and $Source -lt ($Entry['SrcRangeStart'] + $Entry['RangeLength'])) {
            return $Entry['DstRangeStart'] + ($Source - $Entry['SrcRangeStart'])
        }
    }
    return $Source
}

$InputData = Get-Content -Path '.\d05_input'

$SeedsToBePlanted = [System.Collections.Generic.List[uint]]::new()
$Maps = [System.Collections.Generic.Dictionary[string, System.Collections.Generic.List[hashtable]]]::new()

$Mode = ''
foreach ($Line in $InputData) {
    if ($Line -eq '') {
        continue
    } elseif ($Line -match '^seeds:.*$') {
        foreach ($Seed in ($Line -split ':\s+')[1] -split '\s+') {
            $SeedsToBePlanted.Add([uint]$Seed)
        }
        continue
    } elseif ($Line -match '^(.*) map:') {
        $Mode = $Matches[1]
        $Maps.Add($Mode, [System.Collections.Generic.List[hashtable]]::new())
        continue
    }
    # only data lines should be left
    if ($Mode -eq '') {
        throw 'mode not set'
    }
    if ($Line -notmatch '\s*\d+\s+\d+\s+\d+') {
        throw 'invalid line'
    }
    [uint] $DstRangeStart, [uint] $SrcRangeStart, [uint] $RangeLength = $Line -split '\s+'
    $Maps[$Mode].Add(@{
        SrcRangeStart = $SrcRangeStart
        DstRangeStart = $DstRangeStart
        RangeLength = $RangeLength
    })
}

$Min = [uint]::MaxValue
foreach ($Seed in $SeedsToBePlanted) {
    $Soil = Get-DestinationBySource $Seed $Maps['seed-to-soil']
    $Fertilizer = Get-DestinationBySource $Soil $Maps['soil-to-fertilizer']
    $Water = Get-DestinationBySource $Fertilizer $Maps['fertilizer-to-water']
    $Light = Get-DestinationBySource $Water $Maps['water-to-light']
    $Temperature = Get-DestinationBySource $Light $Maps['light-to-temperature']
    $Humidity = Get-DestinationBySource $Temperature $Maps['temperature-to-humidity']
    $Location = Get-DestinationBySource $Humidity $Maps['humidity-to-location']
    if ($Location -lt $Min) {
        $Min = $Location
    }
}
if ($Min -eq [uint]::MaxValue) {
    throw 'no result'
}
$Min