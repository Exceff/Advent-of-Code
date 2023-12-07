Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d02_input'

$Sum = 0
foreach ($Line in $InputData) {
    $Maximums = @{
        red = 0
        green = 0
        blue = 0
    }
    $GameInfo, $RoundsInfo = $Line -split ': '
    $Rounds = $RoundsInfo -split '; '
    foreach ($Round in $Rounds) {
        $Items = $Round -split ', '
        foreach ($Item in $Items) {
            [int] $Number, [string] $Color = $Item -split ' '
            if ($Number -gt $Maximums[$Color]) {
                $Maximums[$Color] = $Number
            }
        }
    }
    $Sum += $Maximums['red'] * $Maximums['green'] * $Maximums['blue']
}
$Sum
