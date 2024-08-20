using module modules\colortune\Get-ColorTune.psm1
using module .\Read-CheckSum.psm1
using module .\New-CheckSum.psm1
Function Test-Verification (){
    [cmdletbinding()]
    [OutputType("PsCustomObject")]
    param(
        [Parameter(Mandatory=$true)]
        [String]$filepath
    )
    $resolved_path = $null
    try {
        $resolved_path = (resolve-Path -path $filepath).path
        [console]::write("Generating New Verification: $(Get-ColorTune -Text "Hashed Checksums" -color Yellow)`n")
        $checksum = Read-CheckSum -FromString (New-CheckSum -Path $resolved_path)
        $checksum_verify = Read-CheckSum -Path $resolved_path
    }
    catch [System.Exception] {
        [console]::write("$(Get-ColorTune -Text "Souce Path not found:" -color red) $Path $($_.Exception.Message)`n")
        throw [System.Exception]::new("Source Path not found: $Path $($_.Exception.Message)")
    }


    $verification_results = @()
    [console]::write("`nRunning Verification: $(Get-ColorTune -Text "Hashed Checksums" -color Yellow)`n")
    $checksum
    
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
    [console]::write("  └─ Verified o--($(Get-ColorTune -Text "$($CheckSum.count)" -color Magenta) / $($CheckSum.count) Files)`n")
    return $verification_results
}
Export-ModuleMember -Function Test-Verification