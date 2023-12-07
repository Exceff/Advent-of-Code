Set-StrictMode -Version latest

$InputData = Get-Content -Path '.\d04_input'

$Number = 0
do {
    $Md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
    $Utf8 = New-Object -TypeName System.Text.UTF8Encoding
    $Hash = [System.BitConverter]::ToString($Md5.ComputeHash($Utf8.GetBytes($InputData + ++$Number)))
} while ($Hash.Substring(0, 7) -ne '00-00-0')

$Number