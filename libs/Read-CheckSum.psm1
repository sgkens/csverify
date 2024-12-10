using module modules\colortune\Get-ColorTune.psm1

Function Read-CheckSum {
    [cmdletbinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $false)]
        [string]$File,
        [Parameter(Mandatory = $false)]
        [string]$FromString
    )

    try {

        if ($FromString) {
            $verification = $FromString 
            [console]::write("  └─◉ reading checksums from string`n")            
        }
        else {
            $File = $(Get-ItemProperty $File).FullName
            [console]::write("  └─◉ parsing checksums from $($global:_csverify.prop.invoke((Get-ItemProperty $File).fullname))`n")
            $verification = (Get-Content -Path $File -Raw)
        }
    }
    catch {
        [console]::write("  └─◉ $(Get-ColorTune -Text "Error: " -color red) $($_.Exception.Message)`n")
        return;
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