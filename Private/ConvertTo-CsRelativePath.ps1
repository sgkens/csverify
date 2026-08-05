function ConvertTo-CsRelativePath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )

    $normalized = $Path.Trim().Replace([System.IO.Path]::DirectorySeparatorChar, '/')
    if ([System.IO.Path]::AltDirectorySeparatorChar -ne [System.IO.Path]::DirectorySeparatorChar) {
        $normalized = $normalized.Replace([System.IO.Path]::AltDirectorySeparatorChar, '/')
    }
    $normalized = $normalized.Replace('\', '/')

    if ($normalized.StartsWith('./', [System.StringComparison]::Ordinal)) {
        $normalized = $normalized.Substring(2)
    }

    if ([string]::IsNullOrWhiteSpace($normalized)) {
        throw [System.FormatException]::new('Checksum record path cannot be empty.')
    }

    if ([System.IO.Path]::IsPathRooted($normalized) -or $normalized -match '^[A-Za-z]:') {
        throw [System.FormatException]::new("Checksum record path must be relative: $Path")
    }

    $segments = $normalized.Split('/', [System.StringSplitOptions]::None)
    if ($segments -contains '..' -or $segments -contains '') {
        throw [System.FormatException]::new("Checksum record path is invalid: $Path")
    }

    return $normalized
}
