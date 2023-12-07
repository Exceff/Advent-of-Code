Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d04_input'

$Overlaps = 0
foreach ($Line in $InputData) {
    $Elf1, $Elf2 = $Line -split ','
    [int] $Elf1From, [int] $Elf1To = $Elf1 -split '-'
    [int] $Elf2From, [int] $Elf2To = $Elf2 -split '-'
    if (($Elf1From -le $Elf2From -and $Elf1To -ge $Elf2From) -or ($Elf2From -le $Elf1From -and $Elf2To -ge $Elf1From)) {
        $Overlaps++
    }
}

$Overlaps