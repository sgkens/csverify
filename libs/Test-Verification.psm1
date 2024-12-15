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
        $path = $(Get-ItemProperty $path).FullName
        [console]::write("-─◉ testing verification file $($global:_csverify.prop.invoke("$path\tools\verification.txt"))`n")
        $checksum = Read-CheckSum -FromString (New-CheckSum -Path $path)
        $checksum_verify = Read-CheckSum -File "$path\tools\verification.txt"
    }
    catch [System.Exception] {
        [console]::write("  └─◉ $(Get-ColorTune -Text "souce path not found" -color red) $Path $($_.Exception.Message)`n")
    }

    $verification_results = @()
    [console]::write("  └─◉ running $($global:_csverify.prop.invoke("checksum")) verification`n")
    
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
        foreach ($f in $verification_results.where({ $_.Status -match "Failed" })) {
            [console]::write(" $($global:_csverify.failedataWriter.invoke($f.Path))`n") 
        }
        throw [system.exception]::new("─◉ verification failed ($(Get-ColorTune -Text "$failed failed" -color red) of $($CheckSum.count) files)")
    }else{
        [console]::write("  └─◉ $(csole -s 'verification successfull' -c green)`n") 
        [console]::write(" $($global:_csverify.kvString.invoke("ReadFromVerificationFile", $CheckSum.count))")
        [console]::write(" $($global:_csverify.kvString.invoke("ReadFromRootFolder", $checksum_verify.count))`n")
        [console]::write("  └─◉ result $(csole -s $($CheckSum.count)) files verified-($(Get-ColorTune -Text "$($checksum_verify.count)" -color green) of $($CheckSum.count) files)`n")
    }
    return $verification_results
}
Export-ModuleMember -Function Test-Verification