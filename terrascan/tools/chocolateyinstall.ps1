$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'terrascan*'
  
  url           = 'https://github.com/tenable/terrascan/releases/download/v1.18.4/terrascan_1.18.4_Windows_i386.zip'
  checksum      = '59981e2c64f3e2a174201105aa2c6f92757542eb1ef0b316a63ebfcf1e655899'
  checksumType  = 'sha256'
  url64bit      = 'https://github.com/tenable/terrascan/releases/download/v1.18.4/terrascan_1.18.4_Windows_x86_64.zip'
  checksum64    = '6c03d4605de71779eb28123c46d7909c468498f6bde7a0615dc35b31717266c0'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
