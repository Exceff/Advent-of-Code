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

($ElfCalories | Measure-Object -Maximum).Maximum