$ErrorActionPreference = 'Stop';

$packageName  = 'dellcommandupdate'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://downloads.dell.com/FOLDER07820512M/1/Dell-Command-Update-Application_8DGG4_WIN_4.4.0_A00.EXE'
$checksum = '66fe419e9b7b9f751a43e3c109e2e7eb'

$packageArgs = @{
  packageName   = $packageName
  softwareName  = 'Dell Command | Update'
  fileType      = 'exe'
  silentArgs    = "/s"
  validExitCodes= @(0)
  url           = $url
  checksum      = $checksum
  checksumType  = 'md5' # Compatible with CatalogPC.xml
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs 
