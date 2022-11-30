$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://dl.dell.com/FOLDER09268356M/1/Dell-Command-Update-Windows-Universal-Application_CJ0G9_WIN_4.7.1_A00.EXE'
$checksum = 'f702bef5204302868cff794eb6d8820da02044b741479b27f425867a9491bef7'
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
