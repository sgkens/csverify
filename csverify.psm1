using module libs\Read-CheckSum.psm1
using module libs\New-CheckSum.psm1
using module libs\New-VerificationFile.psm1
using module libs\Test-Verification.psm1


$global:_csverify = @{
    rootpath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
    kvString = {
        param([string]$keyName, [string]$valueType)
        [string]$kvString = ""
        $kvString += "$(csole -s ↣ -c cyan) $(csole -s '{' -c yellow)"
        $kvString += " $(csole -s key -c magenta) ($(csole -s $keyName -c magenta))"
        $kvString += " $(csole -s Count -c yellow) ($(csole -s $valueType -c yellow))"
        $kvString += " $(csole -s '}' -c yellow)"
        return $kvString
    }
    prop = {
        param([string]$prop)
        return "$(csole -s ↣ -c cyan) • $(csole -s $prop -c yellow)"
    }
    failedataWriter = {
        param($path)
        return "$(csole -s '--▣' -color darkred) $(csole -s $path -color red) $(csole -s failed -color red)"
    }
}

Export-ModuleMember -Function New-CheckSum, 
                              Read-Checksum, 
                              New-VerificationFile,
                              Test-Verification

                              