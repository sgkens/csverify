using module colortune\Get-ColorTune.psm1
Function Read-CheckSum {
    [cmdletbinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory=$true)]
        $FilePath
    )
    $verification = (Get-Content -Path "$FilePath\VERIFICATION.txt" -Raw)
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
    # foreach($sum in $indivSums){
    #     write-host $suma
    # }
    return $checksumObject
}
Export-ModuleMember -Function Read-CheckSum