Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d09_input'

$TailPositionsVisited = @('0,0')

$PosHeadX = 0
$PosHeadY = 0
$PosTailX = 0
$PosTailY = 0

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
                if ($PosHeadY -gt $PosTailY) {
                    $PosTailX = $PosHeadX
                    $PosTailY = $PosHeadY
                }
                $PosHeadY++
            }

            'D' {
                if ($PosHeadY -lt $PosTailY) {
                    $PosTailX = $PosHeadX
                    $PosTailY = $PosHeadY
                }
                $PosHeadY--
            }

            'R' {
                if ($PosHeadX -gt $PosTailX) {
                    $PosTailX = $PosHeadX
                    $PosTailY = $PosHeadY
                }
                $PosHeadX++
            }

            'L' {
                if ($PosHeadX -lt $PosTailX) {
                    $PosTailX = $PosHeadX
                    $PosTailY = $PosHeadY
                }
                $PosHeadX--
            }

            Default { throw "invalid direction: $_"}
        }

        if ($TailPositionsVisited -notcontains "$PosTailX,$PosTailY") {
            $TailPositionsVisited += "$PosTailX,$PosTailY"
        }
    }

}

return $TailPositionsVisited.TargetCount