$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url64 = 'https://downloads.dell.com/FOLDER10488395M/1/Systems-Management_Application_GG4YM_WN64_2.0.2.2_A00.EXE'
$checksum64 = '4fed54d0a9e15de37b053889a81c67ed'

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
