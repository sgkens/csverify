#---CONFIG----------------------------

$ModuleName           = "commitfusion"
$ModuleManifest       = Test-ModuleManifest -path ".\dist\$ModuleName\$ModuleName`.psd1"
$SemVerVersion        = $ModuleManifest.Version -replace "\.\d+$",""

#---CONFIG----------------------------

#------------------------------------
if(Get-command choco.exe){
  write-host "Chocolatey is installed, skipping install"
  write-host "Pushing to chocolatey https://community.chocolatey.org/"
  choco push .\dist\choco\$($ModuleManifest.CompanyName).$ModuleName.$SemVerVersion.nupkg --source 'https://community.chocolatey.org/' --api-key $CHOCO_API_KEY --source https://push.chocolatey.org/
  write-host "Pushed to chocolatey - Complete"
}else{
  write-host "Chocolatey is not installed, please install chocolatey https://community.chocolatey.org/"
  break;
}