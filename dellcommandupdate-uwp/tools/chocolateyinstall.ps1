﻿$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://downloads.dell.com/FOLDER12925773M/1/Dell-Command-Update-Windows-Universal-Application_P4DJW_WIN64_5.5.0_A00.EXE'
$checksum = '7d46abc002046d15d005a774123973f232080a51bc13f9cb2e3709cc1bd91e73'
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
