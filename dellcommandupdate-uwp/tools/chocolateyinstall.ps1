$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://downloads.dell.com/FOLDER07582763M/1/Dell-Command-Update-Application-for-Windows-10_GRVPK_WIN_4.3.0_A00.EXE'
$checksum = 'c8f879a00b7dde248e52ad334962a80b'

Write-Warning "Ensure that 'Dell Update for Windows 10' is not installed. Any errors from this can be ignored"
# Package version 4.3.0 mistakenly installed "Dell Update" instead of "Dell Command Update", so we need to ensure that is uninstalled first
$dellUpdateUninstallPackageArgs  = @{
  packageName    = 'Dell Update for Windows 10'
  fileType       = 'msi'
  silentArgs     = "{41D2D254-D869-4CD8-B440-5DF49083C4BA} /qn /norestart"
  validExitCodes = @(0, 1605)
}
Uninstall-ChocolateyPackage @dellUpdateUninstallPackageArgs

 # the /factoryinstall parameter makes installer return success instead of '2' (which Chocolatey doesn't like)
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Dell Command | Update for Windows 10'
  fileType      = 'exe'
  silentArgs    = "/s /factoryinstall"
  validExitCodes= @(0)
  url           = $url
  checksum      = $checksum
  checksumType  = 'md5'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs 
