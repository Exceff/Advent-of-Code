Set-StrictMode -Version latest

# Source: https://learn-powershell.net/2013/02/21/fun-with-powershell-and-permutations/
Function Get-StringPermutation {
    <#
        .SYNOPSIS
            Retrieves the permutations of a given string. Works only with a single word.
 
        .DESCRIPTION
            Retrieves the permutations of a given string Works only with a single word.
       
        .PARAMETER String           
            Single string used to give permutations on
       
        .NOTES
            Name: Get-StringPermutation
            Author: Boe Prox
            DateCreated:21 Feb 2013
            DateModifed:21 Feb 2013
 
        .EXAMPLE
            Get-StringPermutation -String "hat"
            Permutation                                                                          
            -----------                                                                          
            hat                                                                                  
            hta                                                                                  
            ath                                                                                  
            aht                                                                                  
            tha                                                                                  
            tah        

            Description
            -----------
            Shows all possible permutations for the string 'hat'.

        .EXAMPLE
            Get-StringPermutation -String "help" | Format-Wide -Column 4            
            help                  hepl                  hlpe                 hlep                
            hpel                  hple                  elph                 elhp                
            ephl                  eplh                  ehlp                 ehpl                
            lphe                  lpeh                  lhep                 lhpe                
            leph                  lehp                  phel                 phle                
            pelh                  pehl                  plhe                 pleh        

            Description
            -----------
            Shows all possible permutations for the string 'hat'.
 
    #>
    [cmdletbinding()]
    Param(
        [parameter(ValueFromPipeline = $True)]
        [string]$String = 'the'
    )
    Begin {
        #region Internal Functions
        Function New-Anagram { 
            Param([int]$NewSize)              
            If ($NewSize -eq 1) {
                return
            }
            For ($i = 0; $i -lt $NewSize; $i++) { 
                New-Anagram  -NewSize ($NewSize - 1)
                If ($NewSize -eq 2) {
                    New-Object PSObject -Property @{
                        Permutation = $stringBuilder.ToString()                  
                    }
                }
                Move-Left -NewSize $NewSize
            }
        }
        Function Move-Left {
            Param([int]$NewSize)        
            $z = 0
            $position = ($Size - $NewSize)
            [char]$temp = $stringBuilder[$position]           
            For ($z = ($position + 1); $z -lt $Size; $z++) {
                $stringBuilder[($z - 1)] = $stringBuilder[$z]               
            }
            $stringBuilder[($z - 1)] = $temp
        }
        #endregion Internal Functions
    }
    Process {
        $size = $String.length
        $stringBuilder = New-Object System.Text.StringBuilder -ArgumentList $String
        New-Anagram -NewSize $Size
    }
    End {}
}

# Source: https://learn-powershell.net/2013/02/21/fun-with-powershell-and-permutations/
Function Get-ArrayPermutation {
    <#
    .SYNOPSIS
    Retrieves the permutations of a given array. Works only with arrays with max 75 items.

    .DESCRIPTION
        Retrieves the permutations of a given array. Works only with arrays with max 75 items.

    .PARAMETER String           
        Array with strings used to give permutations on

    .NOTES
        Name: Get-ArrayPermutation
        Author: Marc R Kellerman
        DateCreated:06 Feb 2015
        DateModifed:06 Feb 2015

    .EXAMPLE
        Get-ArrayPermutation "cat", "dog", "fish"
        Permutation                                                                                                                                                     
        -----------                                                                                                                                                     
        {cat, dog, fish}                                                                                                                                                
        {cat, fish, dog}                                                                                                                                                
        {dog, fish, cat}                                                                                                                                                
        {dog, cat, fish}                                                                                                                                                
        {fish, cat, dog}                                                                                                                                                
        {fish, dog, cat}          

        Description
        -----------
        Shows all possible permutations for the strings in the array.

    .EXAMPLE
        Get-ArrayPermutation "cat", "dog", "fish", "bird" | Format-Wide -Column 3            
        {cat, dog, fish, bird}     {cat, dog, bird, fish}     {cat, fish, bird, dog}                              
        {cat, fish, dog, bird}     {cat, bird, dog, fish}     {cat, bird, fish, dog}                              
        {dog, fish, bird, cat}     {dog, fish, cat, bird}     {dog, bird, cat, fish}                              
        {dog, bird, fish, cat}     {dog, cat, fish, bird}     {dog, cat, bird, fish}                              
        {fish, bird, cat, dog}     {fish, bird, dog, cat}     {fish, cat, dog, bird}                              
        {fish, cat, bird, dog}     {fish, dog, bird, cat}     {fish, dog, cat, bird}                              
        {bird, cat, dog, fish}     {bird, cat, fish, dog}     {bird, dog, fish, cat}                              
        {bird, dog, cat, fish}     {bird, fish, cat, dog}     {bird, fish, dog, cat}         

        Description
        -----------
        Shows all possible permutations for the strings in the array.

#>
    [cmdletbinding()]
    Param(
        [parameter(ValueFromPipeline = $True)]
        $Array = @('cat', 'dog', 'fish')
    )
    Begin {
        If ($Array.Count -lt 2) { Return $Array }
        If ($Array.Count -gt 75) { Throw "Array is too big (MAX: 75)." }
    }
    Process {

        $String = [char[]](48..(48 + $Array.Count - 1)) -join ''

        Get-StringPermutation $String | % {

            $StringPermutation = $_.Permutation
            $Permutation = $StringPermutation[0..($StringPermutation.Length - 1)] | % { $Array[$([byte][char]$_.ToString()) - 48] } 
            [PSCustomObject]@{Permutation = $Permutation }
        }

    }
    End {

    }

}

$InputData = Get-Content -Path '.\d09_input'

$AllPlaces = @()
$Distances = @{}
foreach ($Line in $InputData) {
    $Places, $Distance = $Line -split ' = '
    $Place1, $Place2 = @($Places -split ' to ' | Sort-Object)
    if ($Place1 -notin $AllPlaces) {
        $AllPlaces += $Place1
    }
    if ($Place2 -notin $AllPlaces) {
        $AllPlaces += $Place2
    }
    if ($Distances.Keys -notcontains $Place1) {
        $Distances.$Place1 = @{}
    }
    $Distances.$Place1.$Place2 = $Distance
}
$AllPlaces = $AllPlaces | Sort-Object

$AllPlacePermutations = Get-ArrayPermutation $AllPlaces

Write-Host "Step 2"

$LowestDistance = -1
:outer foreach ($Permutation in $AllPlacePermutations) {
    $PermutationDistance = 0
    for ($i = 1; $i -lt $Permutation.Permutation.Count; $i++) {
        $Place1, $Place2 = @($Permutation.Permutation[($i-1)..$i] | Sort-Object)
        if ($Distances.Keys -contains $Place1 -and $Distances.$Place1.Keys -contains $Place2) {
            $PermutationDistance += $Distances.$Place1.$Place2
        } else {
            continue outer
        }
    }
    if ($LowestDistance -eq -1 -or $PermutationDistance -lt $LowestDistance) {
        $LowestDistance = $PermutationDistance
    }
}

$LowestDistance