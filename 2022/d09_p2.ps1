Set-StrictMode -Version latest

Function Get-Visualization ($PosX, $PosY, $MinPosX, $MaxPosX, $MinPosY, $MaxPosY) {
    $Lines = @()
    for ($CurPosY = $MaxPosY; $CurPosY -ge $MinPosY; $CurPosY--) {
        $Line = [System.Text.StringBuilder]::new()
        for ($CurPosX = $MinPosX; $CurPosX -le $MaxPosX; $CurPosX++) {
            $Symbol = '.'
            for ($PosInRope = $RopeLength - 1; $PosInRope -ge 0; $PosInRope--) {
                if ($PosX[$PosInRope] -eq $CurPosX -and $PosY[$PosInRope] -eq $CurPosY) {
                    if ($PosInRope -eq 0) {
                        $Symbol = 'H'
                    } else {
                        $Symbol = [string]$PosInRope
                    }
                }
            }
            if ($Symbol -eq '.' -and $CurPosX -eq 0 -and $CurPosY -eq 0) {
                $Symbol = 's'
            }
            $Line.Append($Symbol) | Out-Null
        }
        $Lines += ($Line.ToString())
    }

    return $Lines
}

Function Get-VisitedVisualization ($TailPositionsVisited, $MinPosX, $MaxPosX, $MinPosY, $MaxPosY) {
    $Lines = @()
    for ($CurPosY = $MaxPosY; $CurPosY -ge $MinPosY; $CurPosY--) {
        $Line = [System.Text.StringBuilder]::new()
        for ($CurPosX = $MinPosX; $CurPosX -le $MaxPosX; $CurPosX++) {
            if ($CurPosX -eq 0 -and $CurPosY -eq 0) {
                $Symbol = 's'
            } elseif ($TailPositionsVisited -contains "$CurPosX,$CurPosY") {
                $Symbol = '#'
            } else {
                $Symbol = '.'
            }
            
            $Line.Append($Symbol) | Out-Null
        }
        $Lines += ($Line.ToString())
    }

    return $Lines
}

Function Get-VisitedTailPositions ($Instructions, $RopeLength, $Visualize = $false) {
    if ($Visualize) {
        $MinPosX = 0
        $MaxPosX = 0
        $MinPosY = 0
        $MaxPosY = 0
        $AllHeadPositions = Get-VisitedTailPositions $Instructions 1 $false
        foreach ($PositionVisited in $AllHeadPositions) {
            [int] $PosXVisited, [int] $PosYVisited = $PositionVisited -split ','
            if ($PosXVisited -lt $MinPosX) {
                $MinPosX = $PosXVisited
            } elseif ($PosXVisited -gt $MaxPosX) {
                $MaxPosX = $PosXVisited
            }
            if ($PosYVisited -lt $MinPosY) {
                $MinPosY = $PosYVisited
            } elseif ($PosYVisited -gt $MaxPosY) {
                $MaxPosY = $PosYVisited
            }
        }
    }

    $PosX = @{}
    $PosY = @{}

    for ($PosInRope = 0; $PosInRope -lt $RopeLength; $PosInRope++) {
        $PosX[$PosInRope] = 0
        $PosY[$PosInRope] = 0
    }

    $TailPositionsVisited = @('0,0')

    if ($Visualize) {
        Write-Host '== Initial State =='
        Write-Host ''
        Write-Host (@(Get-Visualization $PosX $PosY $MinPosX $MaxPosX $MinPosY $MaxPosY) -join [Environment]::NewLine)
        Write-Host ''
    }
    foreach ($Line in $InputData) {
        $Direction, [int] $TargetCount = $Line -split ' '
        if ($Visualize) {
            Write-Host "== $Line =="
            Write-Host ''
        }
        for ($Count = 0; $Count -lt $TargetCount; $Count++) {
            # (imaginary) predecessor that the head is following
            switch ($Direction) {
                'U' { $PosY[0]++ }
                'D' { $PosY[0]-- }
                'R' { $PosX[0]++ }
                'L' { $PosX[0]-- }
                Default { throw "invalid direction: $_"}
            }

            for ($PosInRope = 1; $PosInRope -lt $RopeLength; $PosInRope++) {
                if ($PosX[($PosInRope-1)] -eq $PosX[$PosInRope] -and $PosY[($PosInRope-1)] - 1 -gt $PosY[$PosInRope]) {
                    $PosY[$PosInRope]++
                } elseif ($PosX[($PosInRope-1)] -eq $PosX[$PosInRope] -and $PosY[($PosInRope-1)] + 1 -lt $PosY[$PosInRope]) {
                    $PosY[$PosInRope]--
                } elseif ($PosX[($PosInRope-1)] - 1 -gt $PosX[$PosInRope] -and $PosY[($PosInRope-1)] -eq $PosY[$PosInRope]) {
                    $PosX[$PosInRope]++
                } elseif ($PosX[($PosInRope-1)] + 1 -lt $PosX[$PosInRope] -and $PosY[($PosInRope-1)] -eq $PosY[$PosInRope]) {
                    $PosX[$PosInRope]--
                } elseif ($PosX[($PosInRope-1)] -gt $PosX[$PosInRope] -and $PosY[($PosInRope-1)] -gt $PosY[$PosInRope] -and ($PosX[($PosInRope-1)] - $PosX[$PosInRope]) + ($PosY[($PosInRope-1)] - $PosY[$PosInRope]) -gt 2) {
                    $PosX[$PosInRope]++
                    $PosY[$PosInRope]++
                } elseif ($PosX[($PosInRope-1)] -gt $PosX[$PosInRope] -and $PosY[($PosInRope-1)] -lt $PosY[$PosInRope] -and ($PosX[($PosInRope-1)] - $PosX[$PosInRope]) + ($PosY[$PosInRope] - $PosY[($PosInRope-1)]) -gt 2) {
                    $PosX[$PosInRope]++
                    $PosY[$PosInRope]--
                } elseif ($PosX[($PosInRope-1)] -lt $PosX[$PosInRope] -and $PosY[($PosInRope-1)] -gt $PosY[$PosInRope] -and ($PosX[$PosInRope] - $PosX[($PosInRope-1)]) + ($PosY[($PosInRope-1)] - $PosY[$PosInRope]) -gt 2) {
                    $PosX[$PosInRope]--
                    $PosY[$PosInRope]++
                } elseif ($PosX[($PosInRope-1)] -lt $PosX[$PosInRope] -and $PosY[($PosInRope-1)] -lt $PosY[$PosInRope] -and ($PosX[$PosInRope] - $PosX[($PosInRope-1)]) + ($PosY[$PosInRope] - $PosY[($PosInRope-1)]) -gt 2) {
                    $PosX[$PosInRope]--
                    $PosY[$PosInRope]--
                }
            }
            if ($TailPositionsVisited -notcontains "$($PosX[($RopeLength-1)]),$($PosY[($RopeLength-1)])") {
                $TailPositionsVisited += "$($PosX[($RopeLength-1)]),$($PosY[($RopeLength-1)])"
            }
            if ($Visualize) {
                Write-Host (@(Get-Visualization $PosX $PosY $MinPosX $MaxPosX $MinPosY $MaxPosY) -join [Environment]::NewLine)
                Write-Host ''
            }
        }
    }

    if ($Visualize) {
        Write-Host '== Result =='
        Write-Host ''
        Write-Host (@(Get-VisitedVisualization $TailPositionsVisited $MinPosX $MaxPosX $MinPosY $MaxPosY) -join [Environment]::NewLine)
        Write-Host ''
    }

    return $TailPositionsVisited
}

$InputData = Get-Content -Path '.\d09_input'

$RopeLength = 10

$Result = @(Get-VisitedTailPositions $InputData $RopeLength $true)

$Result.Count