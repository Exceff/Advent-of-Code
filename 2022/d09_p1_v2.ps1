Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d09_input'

$TailPositionsVisited = @('0,0')

$PosX = @{}
$PosY = @{}
$PosX[0] = 0
$PosY[0] = 0
$PosX[1] = 0
$PosY[1] = 0

foreach ($Line in $InputData) {
    # possible cases:
    # - pos(H) == pos(T) --> no matter where H goes, T stays
    # - posX(H) == posX(T) && $posY(H) < posY(T) --> change posY(T) = oldPos(X) when direction == D
    # - posX(H) == posX(T) && $posY(H) > posY(T) --> change posY(T) = oldPos(X) when direction == U
    # - posX(H) < posX(T) && $posY(H) == posY(T) --> change posY(T) = oldPos(X) when direction == L
    # - posX(H) > posX(T) && $posY(H) == posY(T) --> change posY(T) = oldPos(X) when direction == R
    # - posX(H) < posX(T) && $posY(H) < posY(T) --> change pos(T) = oldPos(H) when direction == L || direction == D
    # - posX(H) < posX(T) && $posY(H) > posY(T) --> change pos(T) = oldPos(H) when direction == L || direction == U
    # - posX(H) > posX(T) && $posY(H) < posY(T) --> change pos(T) = oldPos(H) when direction == R || direction == D
    # - posX(H) > posX(T) && $posY(H) > posY(T) --> change pos(T) = oldPos(H) when direction == R || direction == U
    #
    # grouped by direction
    # U
    # - posX(H) == posX(T) && $posY(H) > posY(T) --> change posY(T) = oldPos(X) when direction == U
    # - posX(H) < posX(T) && $posY(H) > posY(T) --> change pos(T) = oldPos(H) when direction == L || direction == U
    # - posX(H) > posX(T) && $posY(H) > posY(T) --> change pos(T) = oldPos(H) when direction == R || direction == U
    # D
    # - posX(H) == posX(T) && $posY(H) < posY(T) --> change posY(T) = oldPos(X) when direction == D
    # - posX(H) < posX(T) && $posY(H) < posY(T) --> change pos(T) = oldPos(H) when direction == L || direction == D
    # - posX(H) > posX(T) && $posY(H) < posY(T) --> change pos(T) = oldPos(H) when direction == R || direction == D
    # R
    # - posX(H) > posX(T) && $posY(H) == posY(T) --> change posY(T) = oldPos(X) when direction == R
    # - posX(H) > posX(T) && $posY(H) < posY(T) --> change pos(T) = oldPos(H) when direction == R || direction == D
    # - posX(H) > posX(T) && $posY(H) > posY(T) --> change pos(T) = oldPos(H) when direction == R || direction == U
    $Direction, [int] $TargetCount = $Line -split ' '
    for ($Count = 0; $Count -lt $TargetCount; $Count++) {
        switch ($Direction) {
            'U' {
                if ($PosY[0] -gt $PosY[1]) {
                    $PosX[1] = $PosX[0]
                    $PosY[1] = $PosY[0]
                }
                $PosY[0]++
            }

            'D' {
                if ($PosY[0] -lt $PosY[1]) {
                    $PosX[1] = $PosX[0]
                    $PosY[1] = $PosY[0]
                }
                $PosY[0]--
            }

            'R' {
                if ($PosX[0] -gt $PosX[1]) {
                    $PosX[1] = $PosX[0]
                    $PosY[1] = $PosY[0]
                }
                $PosX[0]++
            }

            'L' {
                if ($PosX[0] -lt $PosX[1]) {
                    $PosX[1] = $PosX[0]
                    $PosY[1] = $PosY[0]
                }
                $PosX[0]--
            }

            Default { throw "invalid direction: $_"}
        }

        if ($TailPositionsVisited -notcontains "$($PosX[1]),$($PosY[1])") {
            $TailPositionsVisited += "$($PosX[1]),$($PosY[1])"
        }
    }

}

return $TailPositionsVisited.Count