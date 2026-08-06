@{

    RootModule             = "csverify.psm1"
    ModuleVersion          = '0.3.9'
    CompatiblePSEditions   = @()
    GUID                   = '8089eced-de22-4dae-a7f6-8646d9c69d14'
    Author                 = 'Garvey k. Snow'
    CompanyName            = 'phellams'
    Copyright              = '2024 Garvey k. Snow. All rights reserved.'
    Description            = 'Generates and validates path-bound SHA-256 verification manifests for PowerShell packages and directory trees.'
    PowerShellVersion      = '7.0'
    PowerShellHostName     = ''
    PowerShellHostVersion  = ''
    DotNetFrameworkVersion = ''
    ClrVersion             = ''
    ProcessorArchitecture  = ''
    RequiredModules        = @()
    RequiredAssemblies     = @()
    ScriptsToProcess       = @()
    TypesToProcess         = @()
    FormatsToProcess       = @()
    NestedModules          = @()
    FunctionsToExport      = @(
        'New-CheckSum',
        'Read-CheckSum',
        'New-VerificationFile',
        'Test-Verification'
    )
    CmdletsToExport        = @()
    VariablesToExport      = @()
    AliasesToExport        = @()
    DscResourcesToExport   = @()
    ModuleList             = @()
    FileList               = @()
    PrivateData            = @{
        PSData = @{
            Tags                       = @('automation', 'checksum', 'hash', 'module', 'powershell', 'powershellcore', 'tool', 'utility', 'utility-module')
            LicenseUri                 = 'https://gitlab.com/phellams/csverify/-/blob/develop/LICENSE'
            ProjectUri                 = 'https://gitlab.com/phellams/csverify'
            IconUri                    = 'https://raw.githubusercontent.com/phellams/phellams-general-resources/main/logos/csverify/dist/png/csverify-128x128.png'
            ReleaseNotes               = 'https://gitlab.com/phellams/csverify/-/blob/develop/CHANGELOG.md'
            # CHOCOLATE ---------------------
            ChocoDescription = 'A PowerShell module for generating and validating path-bound SHA-256 verification manifests.'
            ChocoTitle       = 'csverify - PowerShell Checksum Verification Module'
            LicenseUrl       = 'https://gitlab.com/phellams/csverify/-/blob/develop/LICENSE'
            ProjectUrl       = 'https://gitlab.com/phellams/csverify'
            IconUrl          = 'https://raw.githubusercontent.com/phellams/phellams-general-resources/main/logos/csverify/dist/png/csverify-128x128.png'
            Docsurl          = 'https://gitlab.com/phellams/csverify/-/blob/main/README.md'
            MailingListUrl   = 'https://gitlab.com/phellams/csverify/-/blob/main/README.md'
            projectSourceUrl = 'https://gitlab.com/phellams/csverify'
            bugTrackerUrl    = 'https://gitlab.com/phellams/csverify/issues'
            Summary          = 'Generates and validates path-bound SHA-256 verification manifests.'
            # CHOCOLATE ---------------------
            # Prerelease               = 'prerelease'
        }
    }
    HelpInfoURI            = 'https://gitlab.com/phellams/csverify/-/blob/develop/README.md'
    DefaultCommandPrefix   = ''
}
