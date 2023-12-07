<# ---CONFIG--------------------------- #>

$ModuleName           = "commitfusion"
$ProGet_chocInstance  = "https://proget.lab.davilion.online/nuget/Choco"
$ProGet_nugetInstace  = "https://proget.lab.davilion.online/nuget/nuget"
$ProGet_PSGalInstance = 'powershell'

<# ---CONFIG--------------------------- #>






#------------------------------------
# Output FileNames
$ModuleManifest       = Test-ModuleManifest -path ".\dist\$ModuleName\$ModuleName`.psd1"
$zipFileName          = "$($ModuleName).zip"
$SemVerVersion        = $ModuleManifest.Version -replace "\.\d+$",""
$nupkgFileName        = "$($ModuleManifest.CompanyName).$ModuleName.$SemVerVersion.nupkg"

# Force Tls12
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if($ModuleManifest){

  # Push to ProGet Chocolatey
  if(Get-command choco){
    write-host "Checking if Chocolatey is installed, skipping install"
    write-host "Pushing to chocolatey: .\dist\choco\$nupkgFileName"
    choco push ".\dist\choco\$nupkgFileName" --source $ProGet_chocInstance --apikey $PROGET_API_KEY
    write-host "Pushed to chocolatey $nupkgFileName - Complete"
  }
  else{
    write-host "Chocolatey is not installed, installing Chocolatey"
    break;
  }

  # Push to ProGet Nuget
  if(Get-command nuget.exe){
    write-host "Checking if Nuget is installed, skipping install"
    write-host "Pushing to Nuget: .\dist\nuget\$nupkgFileName"
    nuget push ".\dist\nuget\$nupkgFileName" -source $ProGet_nugetInstace -apikey $PROGET_API_KEY
    write-host "Pushed to Nuget $nupkgFileName - Complete"
  }
  else{
    write-host "Nuget is not installed, installing Nuget"
    break;
  }
  

  # puish to proget pscore repo 'powershell gallery'
  # Publish-Module -Path ".\dist\$zipFileName" -Repository pscore -NuGetApiKey $apikey
  # Example of trusting the certificate (not recommended for production)
  # [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
  # Register-PSRepository -name 'pscore_Local_instance' `
  #                       -SourceLocation "https://proget.lab.davilion.online/nuget/pscore/" `
  #                       -PublishLocation (New-Object -TypeName Uri -ArgumentList "https://proget.lab.davilion.online/nuget/pscore/", 'package/').AbsoluteUri `
  #                       -InstallationPolicy "Trusted"
  

  # # Push to ProGet PSGallery
  write-host "Pushing to Powershell-Nuget-Proget: .\dist\psgal\$zipFileName"
  publish-Module `
    -path ".\dist\$ModuleName" `
    -Repository $ProGet_PSGalInstance `
    -NuGetApiKey $PROGET_API_KEY `
    -projecturi $ModuleManifest.ProjectUri `
    -licenseuri $ModuleManifest.LicenseUri `
    -IconUri 'https://gitlab.snowlab.tk/sgkens/resources/-/blob/raw/modules/CommitFusion/dist/v1/ccommits-logo_GitIcon_51.20dpi.png' `
    -ReleaseNotes $ModuleManifest.ReleaseNotes `
    -Tags $ModuleManifest.Tags `
    -Verbose
}



