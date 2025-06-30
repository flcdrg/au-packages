$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://dl.dell.com/FOLDER13309632M/1/Dell-Command-Update-Windows-Universal-Application_M4P6K_WIN64_5.5.0_A00.EXE'
$checksum = 'fe65cc291c8bb4c6d1fed7dc55411071ee9d9c6aeb772830b846c9dd728cd676'
$checksumType = 'sha256'

Write-Warning "Ensure that 'Dell Update for Windows 10' is not installed. Any errors from this can be ignored"
# Package version 4.3.0 mistakenly installed "Dell Update" instead of "Dell Command Update", so we need to ensure that is uninstalled first
$dellUpdateUninstallPackageArgs = @{
  packageName    = 'Dell Update for Windows 10'
  fileType       = 'msi'
  silentArgs     = "{41D2D254-D869-4CD8-B440-5DF49083C4BA} /qn /norestart"
  validExitCodes = @(0, 1605)
}
Uninstall-ChocolateyPackage @dellUpdateUninstallPackageArgs

# the /factoryinstall parameter makes installer return success instead of '2' (which Chocolatey doesn't like)
$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'Dell Command | Update for Windows Universal'
  File           = [IO.Path]::Combine($toolsDir, [IO.Path]::GetFileName($url))
  fileType       = 'exe'
  silentArgs     = "/s /factoryinstall"
  validExitCodes = @(0)
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  UserAgent      = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
}

# Install-ChocolateyPackage @packageArgs

# As Dell have decommissioned downloads.dell.com we're forced to use dl.dell.com instead.
# BUT Dell check user-agents on that URL (and doesn't like Chocolatey's default one), 
# and because of https://github.com/chocolatey/choco/issues/3191
# we can't override the user agent when calling Install-ChocolateyPackage.
# So we resort to doing the download and checksum verification ourselves.
Get-WebFile @packageArgs

Get-ChecksumValid @packageArgs

Install-ChocolateyInstallPackage @packageArgs
