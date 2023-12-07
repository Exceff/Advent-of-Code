Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d03_input'

$Pos = @{
    0 = @{ # Santa
        X = 0
        Y = 0
    }
    1 = @{ # Robo
        X = 0
        Y = 0
    }
}
$HousesVisited = @('0,0') # the starting house is always visited
$Actor = 0
foreach ($Instruction in $InputData.ToCharArray()) {
    switch ($Instruction) {
        ([char]'^') { $Pos.$Actor.'Y'++ }
        ([char]'v') { $Pos.$Actor.'Y'-- }
        ([char]'>') { $Pos.$Actor.'X'++ }
        ([char]'<') { $Pos.$Actor.'X'-- }
    }
    if ($HousesVisited -notcontains "$($Pos.$Actor.'X'),$($Pos.$Actor.'Y')") {
        $HousesVisited += "$($Pos.$Actor.'X'),$($Pos.$Actor.'Y')"
    }
    $Actor = [int]!$Actor
}

$HousesVisited.Count