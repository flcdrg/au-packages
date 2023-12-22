$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'terrascan*'
  
  url           = 'https://github.com/tenable/terrascan/releases/download/v1.18.11/terrascan_1.18.11_Windows_i386.zip'
  checksum      = '0f7c6227b75c8ab4ca26dc26dfa8f5c3df412fde2f5fcb2b08de5c89336a9fa4'
  checksumType  = 'sha256'
  url64bit      = 'https://github.com/tenable/terrascan/releases/download/v1.18.11/terrascan_1.18.11_Windows_x86_64.zip'
  checksum64    = '07aa046177d31132b7f67c515c0f5c3f0883c2d6588db3d64f4c6785d4f89ea4'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
