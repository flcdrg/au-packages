$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://downloads.dell.com/FOLDER10791716M/1/Dell-Command-Update-Windows-Universal-Application_JCVW3_WIN_5.1.0_A00.EXE'
$checksum = '1fb79c2e478a36b356d710ae799aab2153578afd923b2520e8fc64b72510db0d'
$checksumType = 'sha256'

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
  softwareName  = 'Dell Command | Update for Windows Universal'
  fileType      = 'exe'
  silentArgs    = "/s /factoryinstall"
  validExitCodes= @(0)
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs 
