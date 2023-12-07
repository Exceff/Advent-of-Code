Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d02_input'

$ShapeScore = @{
  X = 1 # me: rock
  Y = 2 # me: paper
  Z = 3 # me: scissors
}

$OutcomeScore = @{
  A = @{ # they: rock
    X = 3 # me: rock -> draw
    Y = 6 # me: paper -> win
    Z = 0 # me: scissors -> lose
  }
  
  B = @{ # they: paper
    X = 0 # me: rock -> lose
    Y = 3 # me: paper -> draw
    Z = 6 # me: scissors -> win
  }
  
  C = @{ # they: scissors
    X = 6 # me: rock -> win
    Y = 0 # me: paper -> lose
    Z = 3 # me: scissors -> draw
  }
}

$TotalScore = 0
foreach ($Line in $InputData) {
  $They, $Me = $Line -split ' '
  $TotalScore += $ShapeScore.$Me + $OutcomeScore.$They.$Me
}

$TotalScore