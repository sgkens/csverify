using module libs\Read-CheckSum.psm1
using module libs\New-CheckSum.psm1
using module libs\New-VerificationFile.psm1
using module libs\Test-Verification.psm1


Export-ModuleMember -Function New-CheckSum, 
                              Read-Checksum, 
                              New-VerificationFile,
                              Test-Verification