Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d01_input'

$ElfCalories = @()
$ElfCalories += 0
foreach ($Line in $InputData) {
  if ($Line -eq '') {
    $ElfCalories += 0
  } else {
    $ElfCalories[-1] += [int]$Line
  }
}

$ElfCaloriesSorted = $ElfCalories | Sort-Object
($ElfCaloriesSorted[-1] + $ElfCaloriesSorted[-2] + $ElfCaloriesSorted[-3])