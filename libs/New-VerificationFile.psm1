using module .\modules\colortune\Get-ColorTune.psm1
using module .\Read-CheckSum.psm1
using module .\New-CheckSum.psm1

Function New-VerificationFile {
    [cmdletbinding()]
    [OutputType("pscustomobject")]
    param(
        [Parameter(Mandatory=$false,position=0)]
        [String]$Path,
        [Parameter(Mandatory=$false, position=1)]
        [String]$Output
    )
   
    [console]::write("  └─ Generating Verification File: $(Get-ColorTune -Text "Hashed Checksums" -color Yellow)`n")
    
    $path = $(Get-ItemProperty $Path).FullName
    $outPath = $(Get-ItemProperty $Output).FullName
   
    New-CheckSum -Path $path | Out-File -FilePath "$outPath\VERIFICATION.txt" -Encoding utf8
    
    [console]::write("  └─ $(Get-ColorTune -Text "Verification file created:" -color green) $outPath\VERIFICATION.txt`n")
   
    Read-CheckSum -File "$outPath\VERIFICATION.txt"
}
Export-ModuleMember -Function New-VerificationFile