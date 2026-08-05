[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSUseShouldProcessForStateChangingFunctions',
    '',
    Justification = 'This compatibility command returns a manifest string and does not change system state.'
)]
param()

function New-CheckSum {
    <#
    .SYNOPSIS
        Generates a legacy csverify checksum manifest string for a directory tree.

    .DESCRIPTION
        Enumerates regular files beneath Path, calculates SHA-256 hashes, and returns
        the current human-readable VERIFICATION.txt representation.

    .PARAMETER Path
        Root directory whose files are included in the checksum manifest.

    .EXAMPLE
        New-CheckSum -Path './dist/choco'

    .OUTPUTS
        System.String
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )

    process {
        $rootPath = [System.IO.Path]::GetFullPath($Path)
        if (-not [System.IO.Directory]::Exists($rootPath)) {
            throw [System.IO.DirectoryNotFoundException]::new("Checksum root directory was not found: $Path")
        }

        Write-Verbose "Generating new checksums from $(Format-CsProperty -Value $rootPath)"

        $verificationText = @'
VERIFICATION
Verification is intended to assist the moderators and community
in verifying that this package's contents are trustworthy.

To Verify the files in this package, please download/Install module
csverify using one of the following methods:

Method 1: Install from Powershell Gallery
------------------------------------------------------------------------
Install-Module -Name csverify
Import-Module -Name csverify

Method 2: Install from Chocolatey.org
------------------------------------------------------------------------
choco install csverify

Method 3: Download from GitHub and install from the nupkg or zip file
------------------------------------------------------------------------
https://github.com/phellams/csverify/releases

Method 4: Clone the repository and run the module from source
------------------------------------------------------------------------
git clone https://github.com/phellams/csverify.git
cd csverify
Import-Module ./csverify.psd1

Then run the following command from the root of the module:

Test-Verification -Path ./

-[CHECKSUM HASHES]-
___________________
'@

        $relativePaths = [System.Collections.Generic.List[string]]::new()
        foreach ($filePath in [System.IO.Directory]::EnumerateFiles(
                $rootPath,
                '*',
                [System.IO.SearchOption]::AllDirectories)) {
            $relativePath = ConvertTo-CsRelativePath -Path ([System.IO.Path]::GetRelativePath($rootPath, $filePath))
            $segments = $relativePath.Split('/')

            if ($segments -contains '.git') {
                continue
            }
            if ([System.IO.Path]::GetFileName($relativePath).Equals(
                    'VERIFICATION.txt',
                    [System.StringComparison]::OrdinalIgnoreCase)) {
                continue
            }
            if ([System.IO.Path]::GetExtension($relativePath).Equals(
                    '.nuspec',
                    [System.StringComparison]::OrdinalIgnoreCase)) {
                continue
            }

            $relativePaths.Add($relativePath)
        }

        $relativePaths.Sort([System.StringComparer]::Ordinal)
        $builder = [System.Text.StringBuilder]::new($verificationText.Length + ($relativePaths.Count * 128))
        [void]$builder.AppendLine($verificationText)

        foreach ($relativePath in $relativePaths) {
            $filePath = [System.IO.Path]::Combine(
                $rootPath,
                $relativePath.Replace('/', [System.IO.Path]::DirectorySeparatorChar))
            $fileInfo = [System.IO.FileInfo]::new($filePath)
            $size = ConvertTo-CsDisplaySize -Bytes $fileInfo.Length
            $hash = (Get-FileHash -LiteralPath $filePath -Algorithm SHA256).Hash
            [void]$builder.AppendLine("$size | $hash | ./$relativePath")
        }

        return $builder.ToString().TrimEnd("`r", "`n")
    }
}
