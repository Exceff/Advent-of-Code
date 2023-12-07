Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d12_input'

$ConvertedData = $InputData | ConvertFrom-Json

Function Get-NonRedSums ($Object) {
    if ($Object -is [object[]]) {
        $ObjectSum = 0
        foreach ($Element in $Object) {
            $ObjectSum += Get-NonRedSums $Element
        }
        return $ObjectSum
    } elseif ($Object -is [System.Management.Automation.PSCustomObject]) {
        foreach ($Property in $Object.PSObject.Properties) {
            if ($Property.Value -is [string] -and $Property.Value -eq 'red') {
                return 0
            }
        }
        return Get-NonRedSums $Object.PSObject.Properties.Value
    } elseif ($Object -is [int]) {
        return $Object
    } elseif ($Object -is [string]) {
        return 0
    } else {
        throw "unknown type: $($Object.GetType())"
    }
}

Get-NonRedSums $ConvertedData.PSObject.Properties.Value