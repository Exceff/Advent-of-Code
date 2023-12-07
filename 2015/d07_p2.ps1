Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d07_input'

$RexPositiveInteger = '^\d+$'
$Wires = @{}
$ValueCache = @{}

Function Get-Value ($Name) {
    if ($Name -match $RexPositiveInteger) {
        # specific value
        Write-Host "$([uint16]$Name)"
        return ([uint16]$Name)
    }
    if ($ValueCache.Keys -contains $Name) {
        $Result = $ValueCache.$Name
        Write-Host "[CACHE] $Name = $Result"
        return $Result
    }
    if (-not ($Wires.Keys -contains $Name)) {
        throw "$Name not found"
    }
    $OperationParts = $Wires.$Name -split ' '
    if ($OperationParts.Count -eq 1) {
        # assignment
        $Source = ([uint16](Get-Value $OperationParts[0]))
        $Result = $Source
        Write-Host "$Name = $Source = $Result"
        $ValueCache.$Name = $Result
        return $Result
    } elseif ($OperationParts.Count -eq 2) {
        # NOT
        $Source = ([uint16](Get-Value $OperationParts[1]))
        $Result = ([uint16](65535 - $Source))
        Write-Host "$Name = NOT $($OperationParts[1]) = NOT $Source = $Result"
        $ValueCache.$Name = $Result
        return $Result
    } else {
        $Source1 = ([uint16](Get-Value $OperationParts[0]))
        $Source2 = ([uint16](Get-Value $OperationParts[2]))
        if ($OperationParts[1] -eq 'AND') {
            # and
            $Result = ([uint16]($Source1 -band $Source2))
            Write-Host "$Name = $($OperationParts[0]) AND $($OperationParts[2]) = $Source1 AND $Source2 = $Result"
            $ValueCache.$Name = $Result
            return $Result
        } elseif ($OperationParts[1] -eq 'OR') {
            # or
            $Result = ([uint16]($Source1 -bor $Source2))
            Write-Host "$Name = $($OperationParts[0]) OR $($OperationParts[2]) = $Source1 OR $Source2 = $Result"
            $ValueCache.$Name = $Result
            return $Result
        } elseif ($OperationParts[1] -eq 'LSHIFT') {
            # lshift
            $Result = ([uint16]($Source1 -shl $Source2))
            Write-Host "$Name = $($OperationParts[0]) LSHIFT $($OperationParts[2]) = $Source1 LSHIFT $Source2 = $Result"
            $ValueCache.$Name = $Result
            return $Result
        } else {
            # rshift
            $Result = ([uint16]($Source1 -shr $Source2))
            Write-Host "$Name = $($OperationParts[0]) RSHIFT $($OperationParts[2]) = $Source1 RSHIFT $Source2 = $Result"
            $ValueCache.$Name = $Result
            return $Result
        }
    }
}

foreach ($Line in $InputData) {
    $Operation, $Target = $Line -split ' -> '
    $Wires.$Target = $Operation
}

$Wires.'b' = Get-Value 'a'
$ValueCache = @{}
Get-Value 'a'