Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d07_input'

$LastCommand = $null
$RootDir = @{'..' = $null}
$Cd = $RootDir
foreach ($Line in $InputData) {
    if ($Line[0] -eq [char]'$') { # command
        $null, $Command, $Args = $Line -split ' '
        if ($Command -eq 'cd' -and $Args -is [string]) {
            if ($Args[0] -eq [char]'/') {
                $Cd = $RootDir
            } elseif ($Args -eq '..' -and $null -ne $Cd['..']) {
                $Cd = $Cd['..']
            } elseif ($Args[0] -ne [char]'.' -and $Args[0] -ne [char]'/') {
                if ($cd.Keys -notcontains $Args) {
                    $Cd.Add($Args, @{'..' = $Cd})
                }
                $Cd = $Cd[$Args]
            } else {
                throw "cd: invalid path specified: '$Args'"
            }
            $LastCommand = $Command, $Args -join ' '
        } elseif ($Command -eq 'ls' -and $Args -eq $null) {
            $LastCommand = $Command
        } else {
            throw "unknown command: '$Command'"
        }
    } else { # response
        if ($LastCommand -ne 'ls') {
            throw "unexpected output: $Line"
        }
        $Sum, $FileName = $Line -split ' '
        if ($Sum -eq 'dir') {
            continue
        }
        $Cd.Add($FileName, [int]$Sum)
    }
}

$global:ConditionalSum = 0

Function Get-DirectorySizes ($Dir) {
    $Sum = 0
    foreach ($Name in $Dir.Keys) {
        if ($Name[0] -eq [char]'.') {
            continue
        }
        if ($Dir[$Name] -is [int]) {
            $Sum += $Dir[$Name]
        } else {
            $Sum += Get-DirectorySizes $Dir[$Name]
        }
    }
    if ($Sum -le 100000) {
        $global:ConditionalSum += $Sum
    }
    return $Sum
}

Write-Host "Total sum: $(Get-DirectorySizes $RootDir)"

$global:ConditionalSum