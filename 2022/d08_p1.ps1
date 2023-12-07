Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d08_input'

$Height = $InputData.Count
$Width = $InputData[0].Length

if ($Height -le 2 -or $Width -le 2) {
    return ($Height * $Width)
}

$HighestFromTop = @{}
$HighestFromBottom = @{}

for ($PosFromLeft = 1; $PosFromLeft -lt ($Width - 1); $PosFromLeft++) {
    $HighestFromTop.Add($PosFromLeft, [int]($InputData[0][$PosFromLeft]))
    $HighestFromBottom.Add($PosFromLeft, [int]($InputData[($Height - 1)][$PosFromLeft]))
}

$TreesVisible = @()
for ($PosFromTop = 1; $PosFromTop -lt ($Height - 1); $PosFromTop++) {
    $HighestFromLeft = [int]($InputData[($PosFromTop)][0])
    $HighestFromRight = [int]($InputData[($PosFromTop)][($Width - 1)])
    $PosFromBottom = $Height - 1 - $PosFromTop
    for ($PosFromLeft = 1; $PosFromLeft -lt ($Width - 1); $PosFromLeft++) {
        $PosFromRight = $Width - 1 - $PosFromLeft
        $HeightTopLeft = [int]($InputData[$PosFromTop][$PosFromLeft])
        $HeightTopRight = [int]($InputData[$PosFromTop][$PosFromRight])
        $HeightBottomLeft = [int]($InputData[$PosFromBottom][$PosFromLeft])

        if ($HeightTopLeft -gt $HighestFromLeft) {
            $HighestFromLeft = $HeightTopLeft
            if ($TreesVisible -notcontains "$PosFromTop,$PosFromLeft") {
                $TreesVisible += "$PosFromTop,$PosFromLeft"
            }
        }
        
        if ($HeightTopRight -gt $HighestFromRight) {
            $HighestFromRight = $HeightTopRight
            if ($TreesVisible -notcontains "$PosFromTop,$PosFromRight") {
                $TreesVisible += "$PosFromTop,$PosFromRight"
            }
        }

        if ($HeightTopLeft -gt $HighestFromTop[$PosFromLeft]) {
            $HighestFromTop[$PosFromLeft] = $HeightTopLeft
            if ($TreesVisible -notcontains "$PosFromTop,$PosFromLeft") {
                $TreesVisible += "$PosFromTop,$PosFromLeft"
            }
        }

        if ($HeightBottomLeft -gt $HighestFromBottom[$PosFromLeft]) {
            $HighestFromBottom[$PosFromLeft] = $HeightBottomLeft
            if ($TreesVisible -notcontains "$PosFromBottom,$PosFromLeft") {
                $TreesVisible += "$PosFromBottom,$PosFromLeft"
            }
        }
    }
}

return ($TreesVisible.Count + 2 * $Height + 2 * $Width - 4)
