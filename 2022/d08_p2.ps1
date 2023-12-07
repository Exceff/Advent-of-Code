Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d08_input'

$Height = $InputData.Count
$Width = $InputData[0].Length

if ($Height -le 2 -or $Width -le 2) {
    return 0
}

$HighestScenicScore = 0
for ($PosFromTop = 1; $PosFromTop -lt ($Height - 1); $PosFromTop++) {
    for ($PosFromLeft = 1; $PosFromLeft -lt ($Width - 1); $PosFromLeft++) {
        $PosHeight = [int]($InputData[$PosFromTop][$PosFromLeft])

        $TopScore = 0
        for ($TopSearch = $PosFromTop - 1; $TopSearch -ge 0; $TopSearch--) {
            $TopScore++
            $TopHeight = [int]($InputData[$TopSearch][$PosFromLeft])
            if ($TopHeight -ge $PosHeight) {
                break
            }
        }

        $BottomScore = 0
        for ($BottomSearch = $PosFromTop + 1; $BottomSearch -lt $Height; $BottomSearch++) {
            $BottomScore++
            $BottomHeight = [int]($InputData[$BottomSearch][$PosFromLeft])
            if ($BottomHeight -ge $PosHeight) {
                break
            }
        }

        $LeftScore = 0
        for ($LeftSearch = $PosFromLeft - 1; $LeftSearch -ge 0; $LeftSearch--) {
            $LeftScore++
            $LeftHeight = [int]($InputData[$PosFromTop][$LeftSearch])
            if ($LeftHeight -ge $PosHeight) {
                break
            }
        }

        $RightScore = 0
        for ($RightSearch = $PosFromLeft + 1; $RightSearch -lt $Width; $RightSearch++) {
            $RightScore++
            $RightHeight = [int]($InputData[$PosFromTop][$RightSearch])
            if ($RightHeight -ge $PosHeight) {
                break
            }
        }

        if ($HighestScenicScore -lt ($TopScore * $BottomScore * $LeftScore * $RightScore)) {
            $HighestScenicScore = ($TopScore * $BottomScore * $LeftScore * $RightScore)
        }
    }
}

return $HighestScenicScore
