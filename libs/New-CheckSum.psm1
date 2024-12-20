using module modules\colortune\Get-ColorTune.psm1
using module modules\cfbytes\cfbytes-class.psm1
<#
.SYNOPSIS
#>
Function New-CheckSum (){
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,Position=1)]
        [String]$Path
    )

    $path = $(Get-ItemProperty $Path).FullName

    $VerificationText = @'
VERIFICATION
Verification is intended to assist the moderators and community
in verifying that this package's contents are trustworthy.

To Verify the files in this package, please download/Install module csverify from chocalatey.org or from the powershell gallery.
Install-Module -Name csverify
Import-Module -Name csverify

Alternatively, you can download the latest release from the Releases >> (https://github.com/nytescipts/csverify/releases page.

Then run the following command:
Test-Verification

-[checksum hash]-
___________________
'@
    [console]::write("-─◉ generating new checksums from path $($global:_csverify.prop.invoke("$Path\*"))`n")
    
    # Get all files in the module folder recursively
    $files = Get-ChildItem -Path $path -Recurse -Exclude "VERIFICATION.txt",".git" | 
        Where-Object { $_.PSIsContainer -eq $false } | 
            sort-object -Descending
    
    $hashes = "$VerificationText`n"

    # Calculate individual hashes for each file
    $files | ForEach-Object {
        $relativePath = $_.FullName.Substring($Path.Length + 1)
        $size = [cfbytes]::ConvertAuto($_.Length) -replace " ", ""
        if($_.Length -eq 0){$size = "0.00KB"}
        if($size.Length -lt 6){$size = "$size "}
        $hash = Get-FileHash -Path $_.FullName -Algorithm SHA256 | Select-Object -ExpandProperty Hash
        $hashes += "$size | $($hash.ToString()) | .\$relativePath `n"  
    }
    return $hashes.TrimEnd("`n`n")

}
Export-ModuleMember -Function New-CheckSum
