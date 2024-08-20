#---CONFIG----------------------------

$ModuleName = "csverify"

#---CONFIG----------------------------
$ModuleManifest = Test-ModuleManifest -path .\dist\$modulename\$modulename.psd1

#----Special Config Choco --------------------------------
# Choco supports markdown nuget and psgallary done
$Additional_descriptions = @'
The ***CSVERIFY*** module is designed to assist in ensuring the integrity of a codebase by generating and verifying a **VERIFICATION.txt** file.

## Verification File

**`New-VerificationFile`** generates the verification file. recersivlly compiles a list of all files present. For each file, it computes the SHA256 hash and records the **file**, **path**, **size** and its **hash** in the verification file(**VERIFICATION.txt**).

```powershell
#Default output .\tools\VERIFICATION.txt
cd /path/to/folder
New-VerificationFile 
```

> VERIFICATION.txt output example
<pre>
VERIFICATION
Verification is intended to assist the moderators and community
in verifying that this package's contents are trustworthy.

To Verify the files in this package, please download/Install module csverify from chocalatey.org or from the powershell gallery.
Get-CheckSum -Path $Path
e
-[checksum hash]-
___________________
1.23KB | 37511B972FBE38C353B680D55EC5CFE51C04C79CA3304922301C5AB44BAC94F9 | .\README.md
1.05KB | D3FF5A1DB41D78399BD676A16C9321F127BB52B7E7EBF56B14EC5ABC21971213 | .\LICENSE
0.34KB | 813818335A37527755ABDCF200322962E340E2278BBF3E515B21D4D232D9A92A | .\csverify.psm1
4.44KB | 394B7998E79D6DDE3B6FF1318550ED21BC9671F2C8F1AA2354861A120738B422 | .\csverify.psd1
1.14KB | 7E246407DE6B586B7BB2C46E82E089B72064AB6941F7EE83EDFBF9E0BD7D4CD3 | .\.gitlab-ci.yml
</pre>

## Verification

**`Test-Verification`** is used to verify the integrity of the codebase base it compares the `SHA256` values from **VERIFICATION.txt** file and Returns file report

> Verification output
<pre>
Running Verification: Hashed Checksums
  └─ Verified o--(5 / 5 Files » Found 1 that could not be verified)
Status   hash                                                             Path                                Size
------   ----                                                             ----                                ----
Verified 0DC558C6B5C5B34D9B77D177AEE6130AEAF75C10A0948C635AEC98F5C445790E .\README.md                         0.95KB
Verified D3FF5A1DB41D78399BD676A16C9321F127BB52B7E7EBF56B14EC5ABC21971213 .\LICENSE                           1.05KB
Verified F5CEFD9EE2498D5A6BB80F3F26A6B07FD405F3AB3AB63917426CB31EBF5719B9 .\csverify.psm1                     0.35KB
Verified EB749553314E1280C22EB6CD2E7CF3687EBF0A8D6C259A59C33AA4DFB215D85D .\csverify.psd1                     4.44KB
Verified 7E246407DE6B586B7BB2C46E82E089B72064AB6941F7EE83EDFBF9E0BD7D4CD3 .\.gitlab-ci.yml                    1.14KB
</pre>
New-Commit @params | Format-FusionMD | Update-Changelog -logfile path\to\file | Set-Commit -Confirm
``````

Generate Semver version base on you commits

``````powershell
# generate SemVer Version returns psobject
Get-GitAutoVersion | select version
# only string
(Get-GitAutoVersion).Version
``````

### Default avaliable commit types

> Types are found at $moduleroot/libs/commitfusion.types.json
'@

#----Special Config Choco --------------------------------
$NuSpecParams = @{
  path=".\dist\$ModuleName"
  ModuleName = $ModuleName
  ModuleVersion = $ModuleManifest.Version -replace "\.\d+$",""
  Author = $ModuleManifest.Author
  Description = "$($ModuleManifest.Description)"
  ProjectUrl = $ModuleManifest.PrivateData.PSData.ProjectUri
  IconUri  = 'https://raw.githubusercontent.com/sgkens/resources/main/modules/CommitFusion/dist/v2/commitfusion-icon-x128.png' 
  License = "MIT"
  company = $ModuleManifest.CompanyName
  Tags = $ModuleManifest.Tags
  dependencies = $ModuleManifest.ExternalModuleDependencies
}

$NuSpecParamsChoco = @{
  path=".\dist\$ModuleName"
  ModuleName = $ModuleName
  ModuleVersion = $ModuleManifest.Version -replace "\.\d+$",""
  Author = $ModuleManifest.Author
  Description   = "$($ModuleManifest.Description) `n`n $Additional_descriptions"
  ProjectUrl = $ModuleManifest.PrivateData.PSData.ProjectUri
  IconUri = 'https://raw.githubusercontent.com/sgkens/resources/main/modules/CommitFusion/dist/v2/commitfusion-icon-x128.png' 
  License = "MIT"
  company = $ModuleManifest.CompanyName
  Tags = $ModuleManifest.Tags
  dependencies = $ModuleManifest.ExternalModuleDependencies
}
# --Config--

if(!(Test-Path -path .\dist\nuget)){mkdir .\dist\nuget}
if(!(Test-Path -path .\dist\choco)){mkdir .\dist\choco}
if(!(Test-Path -path .\dist\psgal)){mkdir .\dist\psgal}

# Create Zip With .nuspec file for PSGallery
write-host -foregroundColor Yellow "Creating Zip File for PSGallery"
$zipFileName = "$($NuSpecParams.ModuleName).zip"
compress-archive -path .\dist\$ModuleName\* -destinationpath .\dist\psgal\$zipFileName -compressionlevel optimal -update

# Create
New-NuspecPacakgeFile @NuSpecParams
Start-sleep -Seconds 1 # Wait for file to be created
New-NupkgPacakge -path .\dist\$ModuleName  -outpath .\dist\nuget

# Chocolatey Supports markdown in the description field so create a new nuspec file with additional descriptions in markdown
New-NuspecPacakgeFile @NuSpecParamsChoco
Start-sleep -Seconds 1 # Wait for file to be created
New-NupkgPacakge -path .\dist\$ModuleName  -outpath .\dist\choco

