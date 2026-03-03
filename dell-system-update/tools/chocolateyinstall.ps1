$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url64 = 'https://downloads.dell.com/FOLDER14217017M/1/Systems-Management_Application_RXKJ5_WN64_2.2.0.1_A00.EXE'
$checksum64 = '98bd636e3b806f6fb0820a6abf4c26bf'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'dell-system-update*'
  fileType      = 'exe'
  silentArgs    = "/s"
  
  validExitCodes= @(0) #please insert other valid exit codes here
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= 'md5'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
