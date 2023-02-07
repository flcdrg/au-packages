$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'terrascan*'
  
  url           = 'https://github.com/tenable/terrascan/releases/download/v1.18.0/terrascan_1.18.0_Windows_i386.zip'
  checksum      = '7a5b845788076f671206f3dab2cef6d522aeb4e92a4880b3b5d3093729948db5'
  checksumType  = 'sha256'
  url64bit      = 'https://github.com/tenable/terrascan/releases/download/v1.18.0/terrascan_1.18.0_Windows_x86_64.zip'
  checksum64    = '30e985763f284cec1db2c6bf41c66eff9127b687c2fe0a1e7fcd4c58b6300a83'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
