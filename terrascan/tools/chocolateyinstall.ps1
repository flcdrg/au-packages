$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'terrascan*'
  
  url           = 'https://github.com/tenable/terrascan/releases/download/v1.18.5/terrascan_1.18.5_Windows_i386.zip'
  checksum      = '71a33cdfd33bd962f1fdb84ad44818145d998bf48045bc93d2df461a9de5eeaf'
  checksumType  = 'sha256'
  url64bit      = 'https://github.com/tenable/terrascan/releases/download/v1.18.5/terrascan_1.18.5_Windows_x86_64.zip'
  checksum64    = '1f7d99147af4e7a12a7aaf6722826f30d67fe1af4b5234a3b961dea05acb4198'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
