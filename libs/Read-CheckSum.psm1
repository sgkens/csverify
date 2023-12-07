using module colortune\Get-ColorTune.psm1
Function Read-CheckSum {
    [cmdletbinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory=$false)]
        [string]$Path,
        [Parameter(Mandatory=$false)]
        [string]$FromString
    )
    if ($path -eq '.\') { $path = "$((Get-Location).Path)\tools" }

    if($FromString){
        $verification = $FromString 
    }else{
        $verification = (Get-Content -Path "$Path\VERIFICATION.txt" -Raw)
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