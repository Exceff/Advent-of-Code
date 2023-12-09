Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d08_input'

$Instructions = [string[]][char[]]$InputData[0]
$Network = [System.Collections.Generic.Dictionary[string, Tuple[string, string]]]::new()
foreach ($Line in $InputData[2..($InputData.Length - 1)]) {
    $Node, $Neighbors = $Line -split '\s*=\s*'
    $NeighborLeft, $NeighborRight = $Neighbors.Trim('()') -split ',\s*'
    $Network.Add($Node, [Tuple[string, string]]::new($NeighborLeft, $NeighborRight))
}

$StepCount = 0
$Node = 'AAA'
:Outer while ($true) {
    foreach ($Instruction in $Instructions) {
        $StepCount++
        switch($Instruction) {
            'L' { $Node = $Network[$Node][0] }
            'R' { $Node = $Network[$Node][1] }
            default { throw 'instructions unclear, got stuck in camel' }
        }
        if ($Node -eq 'ZZZ') {
            break Outer
        }
    }
}
$StepCount