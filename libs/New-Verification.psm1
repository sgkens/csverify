using module colortune\Get-ColorTune.psm1
using module .\Read-CheckSum.psm1
using module .\New-CheckSum.psm1

Function New-Verification {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$false)]
        [String]$Path,
        [Parameter(Mandatory=$false)]
        [String]$Outpath
    )
    if($path -eq '.\'){ $path = (get-location).path }
    if ($outpath.Length -eq 0) { $outpath = "$Path\tools"}

    New-CheckSum -Path $Path | Out-File -FilePath "$outpath\VERIFICATION.txt" -Encoding utf8
    [console]::write("$(Get-ColorTune -Text "Verification file created:" -color green) $($outpath)\VERIFICATION.txt")
    Read-CheckSum -FilePath $outpath
}
Export-ModuleMember -Function New-Verification