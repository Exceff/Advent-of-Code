Set-StrictMode -Version latest

Function FindNumber([string] $String) {
    $String = $String.Replace('one', '1').Replace('two', '2').Replace('three', '3').Replace('four', '4').Replace('five', '5').Replace('six', '6').Replace('seven', '7').Replace('eight', '8').Replace('nine', '9')
    $MyMatches = ([Regex]'\d').Matches($String)
    if ($MyMatches) {
        return [int][string]$MyMatches[0].Value
    }
    return -1
}

$InputData = Get-Content -Path '.\d01_input'

$Sum = 0
foreach ($Line in $InputData) {
    for ($i = 1; $i -le $Line.Length; $i++) {
        $FirstNumber = FindNumber $Line.Substring(0, $i)
        if ($firstNumber -ne -1) {
            break
        }
    }
    for ($i = ($Line.Length - 1); $i -ge 0; $i--) {
        $LastNumber = FindNumber $Line.Substring($i)
        if ($LastNumber -ne -1) {
            break
        }
    }
    if ($FirstNumber -eq -1 -or $LastNumber -eq -1) {
        throw 'not all digits found for line ' + $Line
    }
    
    $LineValue = $FirstNumber * 10 + $LastNumber
    $Sum += $LineValue
}
$Sum
