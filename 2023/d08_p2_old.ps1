Set-StrictMode -Version latest

# This version should eventually work, but it would probably take ages given the real input data.

$InputData = Get-Content -Path '.\d08_input'

$Instructions = [string[]][char[]]$InputData[0]
$Network = [System.Collections.Generic.Dictionary[string, Tuple[string, string]]]::new()
foreach ($Line in $InputData[2..($InputData.Length - 1)]) {
    $Node, $Neighbors = $Line -split '\s*=\s*'
    $NeighborLeft, $NeighborRight = $Neighbors.Trim('()') -split ',\s*'
    $Network.Add($Node, [Tuple[string, string]]::new($NeighborLeft, $NeighborRight))
}

$StepCount = 0
$Nodes = $Network.Keys | Where-Object { $_[-1] -eq 'A' }
:Outer while ($true) {
    foreach ($Instruction in $Instructions) {
        $StepCount++
        switch($Instruction) {
            'L' { $Index = 0 }
            'R' { $Index = 1 }
            default { throw 'instructions unclear, got stuck in camel' }
        }
        $Finished = $true
        foreach ($i in 0..($Nodes.Count - 1)) {
            $Nodes[$i] = $Network[$Nodes[$i]][$Index]
            if ($Finished -and $Nodes[$i][-1] -ne 'Z') {
                $Finished = $false
            }
        }
        if ($Finished) {
            break Outer
        }
    }
}
$StepCount