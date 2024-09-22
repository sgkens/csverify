using module modules\colortune\Get-ColorTune.psm1
using module .\Read-CheckSum.psm1
using module .\New-CheckSum.psm1
Function Test-Verification (){
    [cmdletbinding()]
    [OutputType("System.Collections.ArrayList")]
    param(
        [Parameter(Mandatory=$true)]
        [String]$path
    )

    try {
        $path = $(Get-ItemProperty $path)
        [console]::write("Generating New Verification: $(Get-ColorTune -Text "Hashed Checksums" -color Yellow)`n")

        [console]::write("  └─• Generating Checksums of current Root: o--($(Get-ColorTune -Text $path -color cyan))`n")
        $checksum = Read-CheckSum -FromString (New-CheckSum -Path $path)

        [console]::write("  └─• Reading [Checksums]<=>[Hashes] from file: o--($(Get-ColorTune -Text $path -color cyan))`n")
        $checksum_verify = Read-CheckSum -File "$path\tools\VERIFICATION.txt"
    }
    catch [System.Exception] {
        [console]::write("  └─• $(Get-ColorTune -Text "Souce Path not found:" -color red) $Path $($_.Exception.Message)`n")
    }

    $verification_results = @()
    [console]::write("  └─• Running => [CheckSum] Verification: $(Get-ColorTune -Text "Hashed Checksums" -color Yellow)`n")
    
    foreach($item in $checksum){
        if($item.Path -eq $checksum_verify.Where({$_.Path -eq $item.Path}).Path){
            if($item.hash -eq $checksum_verify.where({$_.hash -eq $item.hash}).hash){
                $verification_results += [pscustomobject]@{
                    Status = "$(Get-ColorTune -Text "Verified" -color Green)"
                    hash = "$(Get-ColorTune -Text "$($item.hash)" -color Green)"
                    Path = $item.Path
                    Size = $item.Size
                }
            }
            else{
                $verification_results += [pscustomobject]@{
                    Status = "$(Get-ColorTune -Text "Failed" -color Red)"
                    hash = "$(Get-ColorTune -Text "$($item.hash)" -color Red)"
                    Path = $item.Path
                    Size = $item.Size   
                }
            }
        }
    }
    [int]$failed = $verification_results.where({ $_.Status -match "Failed" }).count
    if ($failed -ne 0) {
        throw [system.exception]::new("Verification Failed ($(Get-ColorTune -Text "$failed failed" -color red) of $($CheckSum.count) Files)")
    }else{
        [console]::write("  └─• Verification Successfull o--($(Get-ColorTune -Text "$($CheckSum.count)" -color green) of $($CheckSum.count) Files)`n")
    }
    return $verification_results
}
Export-ModuleMember -Function Test-Verification