Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d07_input'

$CardValueMap = @{
    'A' = 12
    'K' = 11
    'Q' = 10
    'T' = 9
    '9' = 8
    '8' = 7
    '7' = 6
    '6' = 5
    '5' = 4
    '4' = 3
    '3' = 2
    '2' = 1
    'J' = 0
}

$Hands = [System.Collections.Generic.List[hashtable]]::new()
foreach ($Line in $InputData) {
    [string] $Hand, [uint] $Bid = $Line -split '\s+'
    if ($Hand.Length -ne 5) {
        throw 'invalid card count'
    }
    $CardCounts = [System.Collections.Generic.Dictionary[char, int]]::new()
    [uint] $HandValue = 0 # an internal value used for easier sorting that factors in both ordering rules
    [uint] $CardCountdown = 5
    [uint] $JokerCount = 0
    foreach ($Card in [string[]][char[]] $Hand) {
        $CardCountdown--
        if ($Card -eq 'J') {
            $JokerCount++
        } else {
            $CardCounts[$Card] = $CardCounts.ContainsKey($Card) ? $CardCounts[$Card] + 1 : 1
        }
        $HandValue += $CardValueMap[$Card] * [Math]::Pow(13, $CardCountdown) # for second ordering rule
    }
    $SortedCardCounts = @($CardCounts.GetEnumerator() | Sort-Object Value -Descending)
    if ($SortedCardCounts.Count -eq 1) {
        $HandType = 6 # five of a kind
    } elseif ($SortedCardCounts.Count -eq 2 -and ($SortedCardCounts[0].Value + $JokerCount) -eq 4) {
        $HandType = 5 # four of a kind
    } elseif ($SortedCardCounts.Count -eq 2 -and ($SortedCardCounts[0].Value + $JokerCount) -eq 3) {
        $HandType = 4 # full house
    } elseif ($SortedCardCounts.Count -eq 3 -and ($SortedCardCounts[0].Value + $JokerCount) -eq 3) {
        $HandType = 3 # three of a kind
    } elseif ($SortedCardCounts.Count -eq 3 -and ($SortedCardCounts[0].Value + $JokerCount) -eq 2) {
        $HandType = 2 # two pair
    } elseif ($SortedCardCounts.Count -eq 4) {
        $HandType = 1 # one pair
    } elseif ($SortedCardCounts.Count -eq 5) {
        $HandType = 0 # high card
    } elseif ($JokerCount -eq 5) {
        $HandType = 6 # five of a kind (special case for jokers only)
    } else {
        throw "invalid hand: $Hand"
    }
    $HandValue += $HandType * [Math]::Pow(13, 5) # for first ordering rule
    $Hands.Add(@{
        HandValue = $HandValue
        Bid = $Bid
    })
}

$SortedHands = $Hands | Sort-Object HandValue
$Result = 0
# a strange bug (?) prevents me from using foreach; the loop variable always becomes the string "System.Collections.Hashtable"
for ($i = 0; $i -lt $SortedHands.Count; $i++) {
    $Result += ($i + 1) * $SortedHands[$i]['Bid']
}
$Result
