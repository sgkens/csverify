Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$privateFiles = @(
    [System.IO.Path]::Combine($PSScriptRoot, 'Private', 'Helpers', 'New-AsciiColor.ps1')
    [System.IO.Path]::Combine($PSScriptRoot, 'Private', 'Helpers', 'ConvertTo-CsDisplaySize.ps1')
    [System.IO.Path]::Combine($PSScriptRoot, 'Private', 'Helpers', 'Format-CsMessage.ps1')
    [System.IO.Path]::Combine($PSScriptRoot, 'Private', 'ConvertTo-CsRelativePath.ps1')
)

$publicFunctions = @(
    'New-CheckSum'
    'Read-CheckSum'
    'New-VerificationFile'
    'Test-Verification'
)

foreach ($file in $privateFiles) {
    . $file
}

foreach ($functionName in $publicFunctions) {
    $file = [System.IO.Path]::Combine($PSScriptRoot, 'Public', "$functionName.ps1")
    . $file
}

Export-ModuleMember -Function $publicFunctions -Alias @() -Variable @()
