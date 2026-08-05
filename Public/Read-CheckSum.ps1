function Read-CheckSum {
    <#
    .SYNOPSIS
        Parses a legacy csverify verification manifest.

    .DESCRIPTION
        Reads checksum records from a file or string and returns raw, unformatted
        objects. Malformed hashes, paths, fields, and duplicate normalized paths
        are rejected.

    .PARAMETER File
        Path to a legacy VERIFICATION.txt file.

    .PARAMETER FromString
        Complete legacy verification manifest content.

    .EXAMPLE
        Read-CheckSum -File './tools/VERIFICATION.txt'

    .OUTPUTS
        PSCustomObject
    #>
    [CmdletBinding(DefaultParameterSetName = 'File')]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, ParameterSetName = 'File', Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$File,

        [Parameter(Mandatory, ParameterSetName = 'String')]
        [AllowEmptyString()]
        [string]$FromString
    )

    if ($PSCmdlet.ParameterSetName -eq 'String') {
        $verification = $FromString
        Write-Verbose 'Reading checksums from string.'
        $source = '<string>'
    }
    else {
        $resolvedFile = [System.IO.Path]::GetFullPath($File)
        if (-not [System.IO.File]::Exists($resolvedFile)) {
            throw [System.IO.FileNotFoundException]::new('Verification file was not found.', $resolvedFile)
        }

        Write-Verbose "Parsing checksums from $(Format-CsProperty -Value $resolvedFile)"
        $verification = [System.IO.File]::ReadAllText($resolvedFile)
        $source = $resolvedFile
    }

    $marker = '___________________'
    $markerIndex = $verification.IndexOf($marker, [System.StringComparison]::Ordinal)
    if ($markerIndex -lt 0) {
        throw [System.FormatException]::new("Checksum marker was not found in $source.")
    }

    $recordText = $verification.Substring($markerIndex + $marker.Length)
    $pathComparer = if ($IsWindows) {
        [System.StringComparer]::OrdinalIgnoreCase
    }
    else {
        [System.StringComparer]::Ordinal
    }
    $paths = [System.Collections.Generic.HashSet[string]]::new($pathComparer)
    $lineNumber = ($verification.Substring(0, $markerIndex) -split "`n").Count

    foreach ($line in ($recordText -split "`r?`n")) {
        $lineNumber++
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }

        $fields = $line.Split([char]'|')
        if ($fields.Count -ne 3) {
            throw [System.FormatException]::new("Malformed checksum record at ${source}:$lineNumber. Expected size, hash, and path fields.")
        }

        $size = $fields[0].Trim()
        $hash = $fields[1].Trim()
        $path = ConvertTo-CsRelativePath -Path $fields[2]

        if ($hash -notmatch '^[0-9A-Fa-f]{64}$') {
            throw [System.FormatException]::new("Invalid SHA-256 hash at ${source}:$lineNumber.")
        }
        if (-not $paths.Add($path)) {
            throw [System.FormatException]::new("Duplicate checksum path at ${source}:${lineNumber}: $path")
        }

        [pscustomobject]@{
            PSTypeName = 'CsVerify.ChecksumRecord'
            Size       = $size
            Hash       = $hash.ToUpperInvariant()
            Path       = "./$path"
        }
    }
}
