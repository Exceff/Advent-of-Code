Set-StrictMode -Version latest

# <ChatGPT>
function Get-LCM {
    param(
        [ulong]$a,
        [ulong]$b
    )

    # Calculate the greatest common divisor (GCD) using Euclidean algorithm
    function Get-GCD {
        param(
            [ulong]$x,
            [ulong]$y
        )

        while ($y -ne 0) {
            $temp = $y
            $y = $x % $y
            $x = $temp
        }

        return $x
    }

    # Calculate LCM using the formula: LCM(a, b) = (a * b) / GCD(a, b)
    $gcd = Get-GCD $a $b
    $lcm = [math]::abs(($a * $b) / $gcd)

    return $lcm
}
# </ChatGPT>

$InputData = Get-Content -Path '.\d08_input'

$Instructions = [string[]][char[]]$InputData[0]
$Network = [System.Collections.Generic.Dictionary[string, Tuple[string, string]]]::new()
foreach ($Line in $InputData[2..($InputData.Length - 1)]) {
    $Node, $Neighbors = $Line -split '\s*=\s*'
    $NeighborLeft, $NeighborRight = $Neighbors.Trim('()') -split ',\s*'
    $Network.Add($Node, [Tuple[string, string]]::new($NeighborLeft, $NeighborRight))
}

[System.Collections.Generic.List[hashtable]] $Nodes = @()
$Network.Keys | Where-Object { $_[-1] -eq 'A' } | Foreach-Object {
    $Nodes.Add(@{
        Node = $_
        Count = [ulong] 0
        IsFinished = $false
    })
}
:Outer while ($true) {
    foreach ($Instruction in $Instructions) {
        switch($Instruction) {
            'L' { $Index = 0 }
            'R' { $Index = 1 }
            default { throw 'instructions unclear, got stuck in camel' }
        }
        $Finished = $true
        foreach ($i in 0..($Nodes.Count - 1)) {
            if ($Nodes[$i]['IsFinished']) {
                continue
            }
            $Finished = $false
            $Nodes[$i]['Node'] = $Network[$Nodes[$i]['Node']][$Index]
            $Nodes[$i]['Count']++
            if ($Nodes[$i]['Node'][-1] -eq 'Z') {
                $Nodes[$i]['IsFinished'] = $true
            }
        }
        if ($Finished) {
            break Outer
        }
    }
}
[ulong] $Result = 1
foreach ($Node in $Nodes) {
    # this only works because the input is tailored accordingly
    $Result = Get-LCM $Result $Node['Count']
}
$Result