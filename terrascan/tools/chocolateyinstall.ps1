$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'terrascan*'
  
  url           = 'https://github.com/tenable/terrascan/releases/download/v1.18.3/terrascan_1.18.3_Windows_i386.zip'
  checksum      = 'fbe13d4a7d0bb3f8cf20c1f2ede2eacded83b43b6d5a41c916d3474d8580e0c3'
  checksumType  = 'sha256'
  url64bit      = 'https://github.com/tenable/terrascan/releases/download/v1.18.3/terrascan_1.18.3_Windows_x86_64.zip'
  checksum64    = '105338ef3082db0b57faeee026443264554c1a46da5f81ee70daf7bdeebdf8a4'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
