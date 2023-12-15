$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'terrascan*'
  
  url           = 'https://github.com/tenable/terrascan/releases/download/v1.18.7/terrascan_1.18.7_Windows_i386.zip'
  checksum      = 'afec472f9948af4952e218cc3be1701a56444bca509c047ec7ec5add79deff4a'
  checksumType  = 'sha256'
  url64bit      = 'https://github.com/tenable/terrascan/releases/download/v1.18.7/terrascan_1.18.7_Windows_x86_64.zip'
  checksum64    = '7daf0894b2b75662239562250b194a6dbd516700c8525625fa376b910970e3cd'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
