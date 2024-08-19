using module colortune\Get-ColorTune.psm1
Function Read-CheckSum {
    [cmdletbinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $false)]
        [string]$Path,
        [Parameter(Mandatory = $false)]
        [string]$FromString
    )

    try {
        if ($FromString) {
            $verification = $FromString 
            [console]::write("  └─ Reading Checksums from String: o--($(Get-ColorTune -Text "$Path\VERIFICATION.txt" -color Magenta)`n")
            [console]::write("  └─ $(Get-ColorTune -Text Done. -color green)`n")
        }
        else {
            [console]::write("  └─ Reading Checksums from file: o--($(Get-ColorTune -Text "$Path\VERIFICATION.txt" -color Magenta)`n")
            $verification = (Get-Content -Path "$Path\tools\VERIFICATION.txt" -Raw)
            [console]::write("  └─ $(Get-ColorTune -Text Done. -color green)`n")
        }
    }
    catch {
        [console]::write("$(Get-ColorTune -Text "[Read-CheckSum]=> Path not found:" -color red) $($path)`n")
        return
    }

    $checksumObject = @()
    foreach ($line in ($verification -split "___________________")[1] -split "`n") {
        if($line.length -ne 0){
            $checksumObject += [pscustomobject]@{
                Size = "$(get-colortune -text $($line.Split("|")[0].Trim()) -color yellow)"
                Hash = $line.Split("|")[1].Trim()
                Path = "$(get-colortune -text $($line.Split("|")[2].Trim()) -color gray)"
            }
        }

    }
    return $checksumObject
}
Export-ModuleMember -Function Read-CheckSum