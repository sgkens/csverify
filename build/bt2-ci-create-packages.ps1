#---CONFIG----------------------------

$ModuleName = "commitfusion"

#---CONFIG----------------------------
$ModuleManifest = Test-ModuleManifest -path .\dist\$modulename\$modulename.psd1

#----Special Config Choco --------------------------------
# Choco supports markdown nuget and psgallary done
$Additional_descriptions = @'
***CommitFusion*** is a **PowerShell** module designed to streamline the process of generating *Conventional Commits Messages* in `git`. Commit messages are constructed using the [🧷Conventional Commits specification](https://www.conventionalcommits.org/en/v1.0.0/) standard, and uses [🧷gitmojis Schema](https://github.com/carloscuesta/gitmoji/blob/master/packages/gitmojis/src/gitmojis.json) see [🧷gitmoji.dev](https://gitmoji.dev), The module allows the construction of a custimized commit message with a number of options.

### Features

🪶 Conventional Commits Standard
🪶 Customizable Commit Message
🪶 Semver Versioning Generator
🪶 Changelog Auto-update with Markdown Auto-format
🪶 Gitmoji Custom Schema

## 🎾 Using Commitfusion

Retrive list of available commit types

``````powershell
Get-CommitTypes
``````

Retrive list of available commit types.

``````powershell
Get-CommitTypes -Semver patch
Get-CommitTypes -Semver minor
Get-CommitTypes -Semver major
Get-CommitTypes -Semver nosemver
``````

Creating a new feature` commit.

``````powershell
# Default Returns ]string]
``````

Assuming you have staged files, you can use the following to commit the changes:

``````powershell
# Apply Commit
New-Commit @params | Set-Commit -Confirm
# Apply Commit and write to changelog file 
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
  IconUrl = 'https://raw.githubusercontent.com/sgkens/resources/main/modules/CommitFusion/dist/v2/commitfusion-icon-x128.png' 
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
  IconUrl  = 'https://raw.githubusercontent.com/sgkens/resources/main/modules/CommitFusion/dist/v2/commitfusion-icon-x128.png' 
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

