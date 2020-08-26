$ErrorActionPreference = 'Stop';

$packageName  = 'dellcommandupdate'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://downloads.dell.com/FOLDER06445000M/1/Dell-Command-Update_5P2R9_WIN_3.1.3_A00.EXE'
$checksum = 'acdd822197afebbb0d7464455fc25fb4'

$packageArgs = @{
  packageName   = $packageName
  softwareName  = 'Dell Command | Update'
  fileType      = 'exe'
  silentArgs    = "/s"
  validExitCodes= @(0)
  url           = $url
  checksum      = $checksum
  checksumType  = 'md5'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs 
