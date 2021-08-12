$ErrorActionPreference = 'Stop';

$packageName  = 'dellcommandupdate'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://downloads.dell.com/FOLDER07582851M/1/Dell-Command-Update-Application_8D5MC_WIN_4.3.0_A00.EXE'
$checksum = 'f66cbad6fd1de9a44b878dbe1cbef22c'

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
