Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d02_input'

$Limits = @{
    red = 12
    green = 13
    blue = 14
}

$Sum = 0
:Game foreach ($Line in $InputData) {
    $GameInfo, $RoundsInfo = $Line -split ': '
    $GameId = [int](($GameInfo -split ' ')[1])
    $Rounds = $RoundsInfo -split '; '
    foreach ($Round in $Rounds) {
        $Items = $Round -split ', '
        foreach ($Item in $Items) {
            [int] $Number, [string] $Color = $Item -split ' '
            if ($Number -gt $Limits[$Color]) {
                continue Game
            }
        }
    }
    $Sum += $GameId
}
$Sum
