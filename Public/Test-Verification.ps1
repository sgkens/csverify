function Test-Verification {
    <#
    .SYNOPSIS
        Verifies a directory against tools/VERIFICATION.txt.

    .DESCRIPTION
        Compares calculated and expected SHA-256 records by normalized relative
        path. Duplicate hashes at different paths are valid. Missing, unexpected,
        and modified files cause a terminating verification failure.

    .PARAMETER Path
        Package root containing the files and tools/VERIFICATION.txt.

    .EXAMPLE
        Test-Verification -Path './dist/choco'

    .OUTPUTS
        CsVerify.VerificationResult
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )

    $rootPath = [System.IO.Path]::GetFullPath($Path)
    if (-not [System.IO.Directory]::Exists($rootPath)) {
        throw [System.IO.DirectoryNotFoundException]::new("Verification root directory was not found: $Path")
    }

    $verificationFile = [System.IO.Path]::Combine($rootPath, 'tools', 'VERIFICATION.txt')
    if (-not [System.IO.File]::Exists($verificationFile)) {
        throw [System.IO.FileNotFoundException]::new('Verification file was not found.', $verificationFile)
    }

    Write-Verbose "Testing VERIFICATION file $(Format-CsProperty -Value $verificationFile)"
    $currentRecords = @(Read-CheckSum -FromString (New-CheckSum -Path $rootPath))
    $expectedRecords = @(Read-CheckSum -File $verificationFile)

    $pathComparer = if ($IsWindows) {
        [System.StringComparer]::OrdinalIgnoreCase
    }
    else {
        [System.StringComparer]::Ordinal
    }

    $expectedByPath = [System.Collections.Generic.Dictionary[string, object]]::new($pathComparer)
    foreach ($record in $expectedRecords) {
        $normalizedPath = ConvertTo-CsRelativePath -Path $record.Path
        if (-not $expectedByPath.TryAdd($normalizedPath, $record)) {
            throw [System.FormatException]::new("Duplicate expected checksum path: $normalizedPath")
        }
    }

    $currentByPath = [System.Collections.Generic.Dictionary[string, object]]::new($pathComparer)
    foreach ($record in $currentRecords) {
        $normalizedPath = ConvertTo-CsRelativePath -Path $record.Path
        if (-not $currentByPath.TryAdd($normalizedPath, $record)) {
            throw [System.FormatException]::new("Duplicate current checksum path: $normalizedPath")
        }
    }

    $results = [System.Collections.Generic.List[object]]::new($currentRecords.Count + $expectedRecords.Count)
    foreach ($record in $currentRecords) {
        $normalizedPath = ConvertTo-CsRelativePath -Path $record.Path
        $expectedRecord = $null

        if (-not $expectedByPath.TryGetValue($normalizedPath, [ref]$expectedRecord)) {
            $results.Add([pscustomobject]@{
                    PSTypeName   = 'CsVerify.VerificationResult'
                    Status       = 'Unexpected'
                    Path         = "./$normalizedPath"
                    Algorithm    = 'SHA256'
                    ExpectedHash = $null
                    ActualHash   = $record.Hash
                    ExpectedSize = $null
                    ActualSize   = $record.Size
                })
            continue
        }

        $status = if ($record.Hash.Equals($expectedRecord.Hash, [System.StringComparison]::OrdinalIgnoreCase)) {
            'Verified'
        }
        else {
            'HashMismatch'
        }

        $results.Add([pscustomobject]@{
                PSTypeName   = 'CsVerify.VerificationResult'
                Status       = $status
                Path         = "./$normalizedPath"
                Algorithm    = 'SHA256'
                ExpectedHash = $expectedRecord.Hash
                ActualHash   = $record.Hash
                ExpectedSize = $expectedRecord.Size
                ActualSize   = $record.Size
            })
    }

    foreach ($expectedRecord in $expectedRecords) {
        $normalizedPath = ConvertTo-CsRelativePath -Path $expectedRecord.Path
        if (-not $currentByPath.ContainsKey($normalizedPath)) {
            $results.Add([pscustomobject]@{
                    PSTypeName   = 'CsVerify.VerificationResult'
                    Status       = 'Missing'
                    Path         = "./$normalizedPath"
                    Algorithm    = 'SHA256'
                    ExpectedHash = $expectedRecord.Hash
                    ActualHash   = $null
                    ExpectedSize = $expectedRecord.Size
                    ActualSize   = $null
                })
        }
    }

    $failed = 0
    foreach ($result in $results) {
        if ($result.Status -ne 'Verified') {
            $failed++
            Write-Verbose (Format-CsFailedPath -Path $result.Path)
        }
    }

    if ($failed -gt 0) {
        throw [System.InvalidOperationException]::new(
            "VERIFICATION failed ($failed failed of $($results.Count) records).")
    }

    Write-Verbose (New-AsciiColor -String 'Verification successful.' -Color 46)
    Write-Verbose (Format-CsKeyValue -Key 'Verified' -Value ([string]$results.Count))
    return $results.ToArray()
}
