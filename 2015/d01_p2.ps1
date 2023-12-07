Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d01_input'

$Floor = 0
$InstructionCount = 0
foreach ($Instruction in $InputData.ToCharArray()) {
    $InstructionCount++
    if ($instruction -eq [char]'(') {
        $Floor++
    } else {
        $Floor--
    }
    if ($Floor -eq -1) {
        return $InstructionCount
    }
}
