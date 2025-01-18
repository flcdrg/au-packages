$ErrorActionPreference = 'Stop';

$packageName  = 'dellcommandupdate'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://downloads.dell.com/FOLDER11914075M/1/Dell-Command-Update-Application_6VFWW_WIN_5.4.0_A00.EXE'
$checksum = 'b62a438922232dddab51a18bdccf4be4d1c9d26b04b048b4a77a77d4cd228b49'
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
