$ErrorActionPreference = 'Stop';

$packageName  = 'dellcommandupdate'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://dl.dell.com/FOLDER08911630M/1/Dell-Command-Update-Application_T97XP_WIN_4.6.0_A00.EXE'
$checksum = '04d8962f907af8139d8394e232c62f562921cc6f709eff58b6d02a93b217058d'
$checksumType = 'sha256'

$packageArgs = @{
  packageName   = $packageName
  softwareName  = 'Dell Command | Update'
  fileType      = 'exe'
  silentArgs    = "/s"
  validExitCodes= @(0)
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs 
