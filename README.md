# <img width="25" src="https://raw.githubusercontent.com/sgkens/resources/main/modules/csverify/dist/v1/csverify-icon-x128.png"/> **CSVERIFY PowerShell Module**

[TOC]

<!--license-->
<a href="https://github.com/sgkens/csverify/">
  <img src="https://img.shields.io/badge/MIT-License-blue?style=&logo=unlicense&color=%23004481"></a>
<!--Code Factor-->
<a href="https://www.codefactor.io/repository/github/sgkens/csverify/">
  <img src="https://www.codefactor.io/repository/github/sgkens/csverify/badge"></a>
<!--Choco-->
<a href="https://community.chocolatey.org/packages/davilion.csverify">
  <img src="https://img.shields.io/chocolatey/dt/davilion.csverify?label=Choco"></a>
<!--[psgallary]-->
<a href="https://www.powershellgallery.com/packages/csverify">
  <img src="https://img.shields.io/powershellgallery/dt/csverify?label=psgallary"></a>

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

## Installation Methods

### 💾 Source

🎫 Clone the repository from GitHub `git clone https://github.com/sgkens/csverify.git` \
🎫 Open a *PowerShell* session and navigate to the cloned repository directory. \
🎫 **Run** the *Module Import* via the command below:

```powershell
# Import the module
git clone https://github.com/sgkens/csverify.git
cd csverify
Import-Module -Name csverify
Get-Module -Name csverify

# Check imported Module Functions
Get-Module -Name csverify | Select-Object -expand ExportedFunctions
Get-Module -Name csverify | select-object version
```

### 💼 Releases

Download the latest release from the [**Releases**](https://github.com/sgkens/csverify/releases) page.

### 📦 Package Repositories

[<img src="https://img.shields.io/powershellgallery/v/csverify?include_prereleases&style=for-the-badge&logo=powershell"/>](https://www.powershellgallery.com/packages/commitfusion/0.4.3) <img src="https://img.shields.io/powershellgallery/dt/csverify?label=Downloads&style=for-the-badge">

```powershell
# Install The Module from the PsGal
Install-Module -Name csverify -force

# Import Module into you powershell session
Import-Module -Name csverify
```

> *Note!*  
> You may need to `Set-ExecutionPolicy` to `RemoteSigned` or `Unrestricted` to install from the PSGallary.

[<img src="https://img.shields.io/chocolatey/v/csverify?style=for-the-badge&logo=chocolatey"/>](https://Chocolatory.org/sgkens/commitfusion) <img src="https://img.shields.io/chocolatey/dt/csverify?label=Downloads&style=for-the-badge">

```powershell
# Install The Module from the PsGal
choco install davilion.csverify

# Import Module into you powershell session
Import-Module -Name csverify
```

> *How-to!* \
> Installing *Chocolatey* Package Repository
[**How to Install**](https)  [🧷https://chocolatey.org/install](https://chocolatey.org/install)

## 📒 Documentaiton

### CMDLETS

#### New-CheckSum
New-CheckSum generates and returns sha256 hash for each within the specified folder. New-Verification unitilizes `New-Checksum` & `Read-CheckSum`.

```powershell
New-CheckSum -Path .\
```

#### Read-CheckSum
Read-CheckSum reads the verification file and returns a `PSCustomObject` *array* containg the file, path, size and hash.

```powershell
Read-CheckSum -Path .\
```

#### New-VerificationFile
New-VerificationFile generates the verification file. recersivlly compiles a list of all files present. For each file, it computes the SHA256 hash and records the **file**, **path**, **size** and its **hash** in the verification file(**VERIFICATION.txt**).

```powershell
New-VerificationFile
```

#### Test-Verification
Test-Verification is used to verify the integrity of the codebase base it compares the `SHA256` values from **VERIFICATION.txt** file and Returns file report.
