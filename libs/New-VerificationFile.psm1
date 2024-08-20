using module .\modules\colortune\Get-ColorTune.psm1
using module .\Read-CheckSum.psm1
using module .\New-CheckSum.psm1

Function New-VerificationFile {
    [cmdletbinding()]
    [OutputType("System.Collections.ArrayList")]
    param(
        [Parameter(Mandatory=$false,position=0)]
        [String]$Path,
        [Parameter(Mandatory=$false)]
        [String]$OutputFile
    )

    New-CheckSum -Path $Path | Out-File -FilePath "$outputfile/tools/VERIFICATION.txt" -Encoding utf8
    [console]::write("$(Get-ColorTune -Text "  └─ Verification file created:" -color green) $($outputfile)`n")
    Read-CheckSum -path $OutputFile
}
Export-ModuleMember -Function New-VerificationFile