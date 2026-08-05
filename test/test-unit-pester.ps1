$modulePath = [System.IO.Path]::Combine($PSScriptRoot, '..', 'csverify.psd1')
Import-Module -Name $modulePath -Force

BeforeAll {
    function New-CsTestPackage {
        param(
            [Parameter(Mandatory)]
            [string]$Root,

            [switch]$DuplicateContent
        )

        [System.IO.Directory]::CreateDirectory($Root) | Out-Null
        $toolsPath = [System.IO.Path]::Combine($Root, 'tools')
        $libPath = [System.IO.Path]::Combine($Root, 'lib')
        [System.IO.Directory]::CreateDirectory($toolsPath) | Out-Null
        [System.IO.Directory]::CreateDirectory($libPath) | Out-Null

        [System.IO.File]::WriteAllText(
            [System.IO.Path]::Combine($Root, 'module.psm1'),
            "function Get-Fixture { 'fixture' }")
        [System.IO.File]::WriteAllText(
            [System.IO.Path]::Combine($libPath, 'helper.ps1'),
            $(if ($DuplicateContent) { "function Get-Fixture { 'fixture' }" } else { "'helper'" }))

        return $toolsPath
    }
}

Describe 'csverify module architecture' {
    It 'exports only the supported public commands' {
        $expected = @(
            'New-CheckSum'
            'New-VerificationFile'
            'Read-CheckSum'
            'Test-Verification'
        )

        $actual = @(Get-Command -Module csverify).Name | Sort-Object
        $actual | Should -Be $expected
    }

    It 'does not expose private helpers or legacy aliases' {
        $exportedCommands = (Get-Module -Name csverify -ErrorAction Stop).ExportedCommands
        $privateNames = @(
            'New-AsciiColor'
            'ConvertTo-CsDisplaySize'
            'csole'
            'Get-ColorTune'
        )

        foreach ($privateName in $privateNames) {
            $exportedCommands.ContainsKey($privateName) | Should -BeFalse
        }
    }
}

Describe 'private helper behavior' {
    InModuleScope csverify {
        It 'formats each supported byte-size band deterministically' {
            ConvertTo-CsDisplaySize -Bytes 0 | Should -BeExactly '0.00KB'
            ConvertTo-CsDisplaySize -Bytes 1MB | Should -BeExactly '1.00MB'
            ConvertTo-CsDisplaySize -Bytes 1GB | Should -BeExactly '1.00GB'
            ConvertTo-CsDisplaySize -Bytes 1TB | Should -BeExactly '1.00TB'
            ConvertTo-CsDisplaySize -Bytes 1PB | Should -BeExactly '1.00PB'
        }

        It 'creates combined ANSI style, foreground, and background sequences' {
            New-AsciiColor -String '' -Color 15 | Should -BeExactly ''
            $colored = New-AsciiColor -String 'value' -Color 46 -BackgroundColor 0 -Format Bold
            $colored | Should -Match ([regex]::Escape("$([char]27)[1;38;5;46;48;5;0mvalue$([char]27)[0m"))
        }

        It 'rejects unsafe relative paths' {
            { ConvertTo-CsRelativePath -Path '  ' } | Should -Throw
            { ConvertTo-CsRelativePath -Path '/rooted/file' } | Should -Throw
            { ConvertTo-CsRelativePath -Path '../outside' } | Should -Throw
        }
    }
}

Describe 'checksum generation and parsing' {
    It 'generates deterministic SHA-256 records' {
        $packageRoot = [System.IO.Path]::Combine($TestDrive, 'generate')
        $null = New-CsTestPackage -Root $packageRoot

        $first = New-CheckSum -Path $packageRoot
        $second = New-CheckSum -Path $packageRoot

        $first | Should -BeOfType [string]
        $first | Should -BeExactly $second
        $records = @(Read-CheckSum -FromString $first)
        $records.Count | Should -Be 2
        $records.Hash | ForEach-Object { $_ | Should -Match '^[0-9A-F]{64}$' }
    }

    It 'returns raw records without ANSI escape sequences' {
        $packageRoot = [System.IO.Path]::Combine($TestDrive, 'raw-records')
        $null = New-CsTestPackage -Root $packageRoot

        $records = @(Read-CheckSum -FromString (New-CheckSum -Path $packageRoot))
        foreach ($record in $records) {
            $record.PSObject.TypeNames | Should -Contain 'CsVerify.ChecksumRecord'
            $record.Path | Should -Not -Match ([regex]::Escape([string][char]27))
            $record.Size | Should -Not -Match ([regex]::Escape([string][char]27))
        }
    }

    It 'creates and reads VERIFICATION.txt' {
        $packageRoot = [System.IO.Path]::Combine($TestDrive, 'verification-file')
        $toolsPath = New-CsTestPackage -Root $packageRoot

        $records = @(New-VerificationFile -RootPath $packageRoot -OutputPath $toolsPath)
        $verificationFile = [System.IO.Path]::Combine($toolsPath, 'VERIFICATION.txt')

        [System.IO.File]::Exists($verificationFile) | Should -BeTrue
        $records.Count | Should -Be 2
    }

    It 'rejects malformed and duplicate manifest records' {
        { Read-CheckSum -FromString 'no marker' } | Should -Throw -ExpectedMessage '*marker*'

        $invalidFields = "VERIFICATION`n___________________`nvalue-only"
        { Read-CheckSum -FromString $invalidFields } | Should -Throw -ExpectedMessage '*Malformed*'

        $invalidHash = "VERIFICATION`n___________________`n0.00KB | invalid | ./file.txt"
        { Read-CheckSum -FromString $invalidHash } | Should -Throw -ExpectedMessage '*Invalid SHA-256*'

        $hash = 'A' * 64
        $duplicate = "VERIFICATION`n___________________`n0.00KB | $hash | ./file.txt`n0.00KB | $hash | ./file.txt"
        { Read-CheckSum -FromString $duplicate } | Should -Throw -ExpectedMessage '*Duplicate checksum path*'
    }

    It 'fails clearly for missing input and output paths' {
        $missingPath = [System.IO.Path]::Combine($TestDrive, 'not-found')
        { New-CheckSum -Path $missingPath } |
            Should -Throw -ExpectedMessage '*root directory was not found*'
        { New-VerificationFile -RootPath $missingPath -OutputPath $TestDrive } |
            Should -Throw -ExpectedMessage '*root directory was not found*'
        { Read-CheckSum -File ([System.IO.Path]::Combine($TestDrive, 'missing.txt')) } |
            Should -Throw -ExpectedMessage '*Verification file was not found*'

        $packageRoot = [System.IO.Path]::Combine($TestDrive, 'missing-output')
        $null = New-CsTestPackage -Root $packageRoot
        { New-VerificationFile -RootPath $packageRoot -OutputPath ([System.IO.Path]::Combine($TestDrive, 'not-found')) } |
            Should -Throw -ExpectedMessage '*output directory was not found*'
    }
}

Describe 'path-bound verification' {
    It 'verifies different paths that contain identical bytes' {
        $packageRoot = [System.IO.Path]::Combine($TestDrive, 'duplicate-content')
        $toolsPath = New-CsTestPackage -Root $packageRoot -DuplicateContent
        $null = New-VerificationFile -RootPath $packageRoot -OutputPath $toolsPath

        $results = @(Test-Verification -Path $packageRoot)

        $results.Count | Should -Be 2
        $results.Status | Should -Not -Contain 'HashMismatch'
        $results.Status | Should -Not -Contain 'Missing'
        $results.Status | Should -Not -Contain 'Unexpected'
        $results.ActualHash | Select-Object -Unique | Should -HaveCount 1
    }

    It 'fails when a listed file is modified' {
        $packageRoot = [System.IO.Path]::Combine($TestDrive, 'modified')
        $toolsPath = New-CsTestPackage -Root $packageRoot
        $null = New-VerificationFile -RootPath $packageRoot -OutputPath $toolsPath
        [System.IO.File]::AppendAllText([System.IO.Path]::Combine($packageRoot, 'module.psm1'), 'changed')

        { Test-Verification -Path $packageRoot } | Should -Throw -ExpectedMessage '*VERIFICATION failed*'
    }

    It 'fails when an expected file is missing' {
        $packageRoot = [System.IO.Path]::Combine($TestDrive, 'missing')
        $toolsPath = New-CsTestPackage -Root $packageRoot
        $null = New-VerificationFile -RootPath $packageRoot -OutputPath $toolsPath
        [System.IO.File]::Delete([System.IO.Path]::Combine($packageRoot, 'module.psm1'))

        { Test-Verification -Path $packageRoot } | Should -Throw -ExpectedMessage '*VERIFICATION failed*'
    }

    It 'fails when an unlisted file is present' {
        $packageRoot = [System.IO.Path]::Combine($TestDrive, 'unexpected')
        $toolsPath = New-CsTestPackage -Root $packageRoot
        $null = New-VerificationFile -RootPath $packageRoot -OutputPath $toolsPath
        [System.IO.File]::WriteAllText([System.IO.Path]::Combine($packageRoot, 'unexpected.txt'), 'unexpected')

        { Test-Verification -Path $packageRoot } | Should -Throw -ExpectedMessage '*VERIFICATION failed*'
    }

    It 'fails clearly when the root or verification file is missing' {
        { Test-Verification -Path ([System.IO.Path]::Combine($TestDrive, 'not-found')) } |
            Should -Throw -ExpectedMessage '*root directory was not found*'

        $packageRoot = [System.IO.Path]::Combine($TestDrive, 'no-manifest')
        $null = New-CsTestPackage -Root $packageRoot
        { Test-Verification -Path $packageRoot } | Should -Throw -ExpectedMessage '*Verification file was not found*'
    }
}
