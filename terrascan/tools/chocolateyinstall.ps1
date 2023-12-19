$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'terrascan*'
  
  url           = 'https://github.com/tenable/terrascan/releases/download/v1.18.9/terrascan_1.18.9_Windows_i386.zip'
  checksum      = 'a20e85ab6eb534b46ced674be5c4f0aae0110083a9e45feb534da4e5df70a94e'
  checksumType  = 'sha256'
  url64bit      = 'https://github.com/tenable/terrascan/releases/download/v1.18.9/terrascan_1.18.9_Windows_x86_64.zip'
  checksum64    = '6c9e0ac8e5518167e6694d7e9df0fbc3e8704c53a49a8e7cd97f9246852b57b6'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
