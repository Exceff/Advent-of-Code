Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d12_input'

$Sum = 0
(Select-String -Input $InputData -Pattern '(-?\d+)' -AllMatches).Matches.Value | Foreach-Object {$Sum += [int]$_}

$Sum