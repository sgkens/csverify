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
   
    [console]::write("generating new verification file $($global:_csverify.prop.invoke($Path))`n")
    
    $path = $(Get-ItemProperty $Path).FullName
    $outPath = $(Get-ItemProperty $Output).FullName
   
    New-CheckSum -Path $path | Out-File -FilePath "$outPath\verification.txt" -Encoding utf8
    
    [console]::write("  └─◉ $(Get-ColorTune -Text "verification file created" -color green) $($global:_csverify.prop.invoke("$Output\verification.txt"))`n")
    
    Read-CheckSum -File "$outPath\verification.txt"
}
Export-ModuleMember -Function New-VerificationFile