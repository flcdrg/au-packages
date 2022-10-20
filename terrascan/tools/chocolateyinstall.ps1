$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'terrascan*'
  
  url           = 'https://github.com/tenable/terrascan/releases/download/v1.16.0/terrascan_1.16.0_Windows_i386.zip'
  checksum      = 'f87298ee977e580c4f37a6793aeee06819e0516df3b02917b1bfd6a9993c4f3d'
  checksumType  = 'sha256'
  url64bit      = 'https://github.com/tenable/terrascan/releases/download/v1.16.0/terrascan_1.16.0_Windows_x86_64.zip'
  checksum64    = '51c94386b67e18048c91e59ebd15038a7456419956f222dd9e7bbf7428da699c'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
