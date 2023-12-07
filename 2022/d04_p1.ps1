Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d04_input'

$FullContainments = 0
foreach ($Line in $InputData) {
    $Elf1, $Elf2 = $Line -split ','
    [int] $Elf1From, [int] $Elf1To = $Elf1 -split '-'
    [int] $Elf2From, [int] $Elf2To = $Elf2 -split '-'
    if (($Elf1From -le $Elf2From -and $Elf1To -ge $Elf2To) -or ($Elf1From -ge $Elf2From -and $Elf1To -le $Elf2To)) {
        $FullContainments++
    }
}

$FullContainments