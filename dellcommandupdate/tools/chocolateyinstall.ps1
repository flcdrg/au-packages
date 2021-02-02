$ErrorActionPreference = 'Stop';

$packageName  = 'dellcommandupdate'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://dl.dell.com/FOLDER06986400M/1/Dell-Command-Update-Application_P5R35_WIN_4.1.0_A00.EXE'
$checksum = 'c22eab1d1e4b45114eb4e89da85fa2d9'

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
