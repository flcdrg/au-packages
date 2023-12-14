$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'terrascan*'
  
  url           = 'https://github.com/tenable/terrascan/releases/download/v1.18.6/terrascan_1.18.6_Windows_i386.zip'
  checksum      = 'fcf4c6bcbcdba51e3a0826076bf25a2699b4496b2e6a31a3d61d014ace904f74'
  checksumType  = 'sha256'
  url64bit      = 'https://github.com/tenable/terrascan/releases/download/v1.18.6/terrascan_1.18.6_Windows_x86_64.zip'
  checksum64    = 'ca42b4144f19da2dd273c83bb6ecc8f434b8fe63a2909f11383ce27eec243a98'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
