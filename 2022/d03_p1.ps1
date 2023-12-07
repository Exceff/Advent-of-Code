Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d03_input'

$PrioritiesSum = 0
foreach ($Line in $InputData) {
  $Items = $Line.ToCharArray()
  $Compartment1 = $Items[0..([int]($Items.Length / 2) - 1)]
  $Compartment2 = $Items[([int]($Items.Length / 2)..($Items.Length - 1))]
  $Compartment1ItemTypes = $Compartment1 | Select-Object -Unique
  $Compartment2ItemTypes = $Compartment2 | Select-Object -Unique
  $CompartmentIntersection = $Compartment1ItemTypes | Where-Object {$Compartment2ItemTypes -ccontains $_}
  if ($CompartmentIntersection -ge [char]'a') {
    $PrioritiesSum += $CompartmentIntersection - [char]'a' + 1
  } else {
    $PrioritiesSum += $CompartmentIntersection - [char]'A' + 27
  }
}

$PrioritiesSum