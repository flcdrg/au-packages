$ErrorActionPreference = 'Stop';

$packageName  = 'dellcommandupdate'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://downloads.dell.com/FOLDER10012380M/1/Dell-Command-Update-Application_30F6M_WIN_4.9.0_A01.EXE'
$checksum = 'f7dd080cf61f26dff5c7442ce0cfac09bfcfdcb7e345a32d5d06d080dbc25aaf'
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
