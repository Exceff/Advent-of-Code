Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d03_input'

$PosX = 0
$PosY = 0
$HousesVisited = @('0,0') # the starting house is always visited
foreach ($Instruction in $InputData.ToCharArray()) {
    switch ($Instruction) {
        ([char]'^') { $PosY++ }
        ([char]'v') { $PosY-- }
        ([char]'>') { $PosX++ }
        ([char]'<') { $PosX-- }
    }
    if ($HousesVisited -notcontains "$PosX,$PosY") {
        $HousesVisited += "$PosX,$PosY"
    }
}

$HousesVisited.Count