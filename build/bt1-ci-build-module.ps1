#---CONFIG----------------------------

# ModuleName
$moduleName  = "csverify"
# Include
$Files       = "csverify.psm1", "csverify.psd1", "LICENSE", "icon.png", "readme.md"
$folders     = "libs"
$exclude     = "Issue#1.txt"

#---CONFIG----------------------------

$AutoVersion = (Get-GitAutoVersion).Version

Build-Module -SourcePath .\ `
             -DestinationPath .\dist `
             -Name $moduleName  `
             -IncrementVersion None `
             -FilesToCopy $Files `
             -ExcludedFiles $exclude `
             -FoldersToCopy $folders `
             -Manifest `
             -Version $AutoVersion