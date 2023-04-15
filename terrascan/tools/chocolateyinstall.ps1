$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'terrascan*'
  
  url           = 'https://github.com/tenable/terrascan/releases/download/v1.18.1/terrascan_1.18.1_Windows_i386.zip'
  checksum      = 'dd8b4d5b551e8ec77664dc33e556a618bc7378b3914f1d983adb81cfc1233205'
  checksumType  = 'sha256'
  url64bit      = 'https://github.com/tenable/terrascan/releases/download/v1.18.1/terrascan_1.18.1_Windows_x86_64.zip'
  checksum64    = '7ca5f5b78452e7cc29e51125f26630db87c25de54dc16876449f0e98e06365a3'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
