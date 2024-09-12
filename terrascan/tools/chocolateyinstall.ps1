$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'terrascan*'
  
  url           = 'https://github.com/tenable/terrascan/releases/download/v1.19.8/terrascan_1.19.8_Windows_i386.zip'
  checksum      = '4600db5dd0c8e15f6b9e45f64019541d0872d1391b963e03484768f72ca27e81'
  checksumType  = 'sha256'
  url64bit      = 'https://github.com/tenable/terrascan/releases/download/v1.19.8/terrascan_1.19.8_Windows_x86_64.zip'
  checksum64    = '0f03b568a713d4f49e0652289e671649f65c78f042f44a882b9fec1b03fa46df'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
