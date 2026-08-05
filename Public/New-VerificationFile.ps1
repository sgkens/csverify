function New-VerificationFile {
    <#
    .SYNOPSIS
        Creates a legacy csverify VERIFICATION.txt file.

    .DESCRIPTION
        Generates a deterministic legacy checksum manifest for RootPath and writes
        it to VERIFICATION.txt beneath OutputPath.

    .PARAMETER RootPath
        Root directory whose files are hashed.

    .PARAMETER OutputPath
        Existing directory that receives VERIFICATION.txt.

    .EXAMPLE
        New-VerificationFile -RootPath './dist/choco' -OutputPath './dist/choco/tools'

    .OUTPUTS
        CsVerify.ChecksumRecord
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$RootPath,

        [Parameter(Mandatory, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath
    )

    $resolvedRootPath = [System.IO.Path]::GetFullPath($RootPath)
    $resolvedOutputPath = [System.IO.Path]::GetFullPath($OutputPath)
    if (-not [System.IO.Directory]::Exists($resolvedRootPath)) {
        throw [System.IO.DirectoryNotFoundException]::new("Checksum root directory was not found: $RootPath")
    }
    if (-not [System.IO.Directory]::Exists($resolvedOutputPath)) {
        throw [System.IO.DirectoryNotFoundException]::new("Verification output directory was not found: $OutputPath")
    }

    $verificationFile = [System.IO.Path]::Combine($resolvedOutputPath, 'VERIFICATION.txt')
    Write-Verbose "Generating new VERIFICATION file for $(Format-CsProperty -Value $resolvedRootPath)"

    if ($PSCmdlet.ShouldProcess($verificationFile, 'Create checksum verification file')) {
        $content = New-CheckSum -Path $resolvedRootPath
        $encoding = [System.Text.UTF8Encoding]::new($false)
        [System.IO.File]::WriteAllText($verificationFile, $content, $encoding)

        Write-Verbose "$(New-AsciiColor -String 'VERIFICATION file created' -Color 46) $(Format-CsProperty -Value $verificationFile)"
        Read-CheckSum -File $verificationFile
    }
}
