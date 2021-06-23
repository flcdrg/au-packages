$ErrorActionPreference = 'Stop';

$packageName  = 'dellcommandupdate'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://downloads.dell.com/FOLDER07414743M/1/Dell-Command-Update-Application_XM3K1_WIN_4.2.1_A00.EXE'
$checksum = '677bacd2255e7374c892c6001bba873a'

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
