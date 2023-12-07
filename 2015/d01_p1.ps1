Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d01_input'

$Up = ($InputData.ToCharArray() -eq [char]'(').Count
$Down = ($InputData.ToCharArray() -eq [char]')').Count

($Up - $Down)