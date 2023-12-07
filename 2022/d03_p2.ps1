Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d03_input'

$PrioritiesSum = 0
$RucksackArray = @()
foreach ($Line in $InputData) {
  $Items = $Line.ToCharArray()
  $RucksackArray += , $Items # array of arrays
  if ($RucksackArray.Count -eq 3) {
    $Rucksack1ItemTypes = $RucksackArray[0] | Select-Object -Unique
    $Rucksack2ItemTypes = $RucksackArray[1] | Select-Object -Unique
    $Rucksack3ItemTypes = $RucksackArray[2] | Select-Object -Unique
    $RucksackIntersection = $Rucksack1ItemTypes | Where-Object {$Rucksack2ItemTypes -ccontains $_}
    $RucksackIntersection = $RucksackIntersection | Where-Object {$Rucksack3ItemTypes -ccontains $_}
    if ($RucksackIntersection -ge [char]'a') {
      $PrioritiesSum += $RucksackIntersection - [char]'a' + 1
    } else {
      $PrioritiesSum += $RucksackIntersection - [char]'A' + 27
    }
    $RucksackArray = @()
  }
}

$PrioritiesSum