$ErrorActionPreference = 'Stop';

$packageName  = 'dellcommandupdate'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://downloads.dell.com/FOLDER07336585M/2/Dell-Command-Update-Application_MJ3C3_WIN_4.2.0_A00.EXE'
$checksum = 'bd751c178d32f88b75ad4fe8454a46ab'

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
