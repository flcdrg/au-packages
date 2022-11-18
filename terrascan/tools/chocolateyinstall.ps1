$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'terrascan*'
  
  url           = 'https://github.com/tenable/terrascan/releases/download/v1.17.0/terrascan_1.17.0_Windows_i386.zip'
  checksum      = '4a476ebaa1784a30155043443f1d6acb463c8d35270d885456f542b923aff7dd'
  checksumType  = 'sha256'
  url64bit      = 'https://github.com/tenable/terrascan/releases/download/v1.17.0/terrascan_1.17.0_Windows_x86_64.zip'
  checksum64    = '7b0fc92107041543a4912e22c12d087f44e928908a177f2d223425438dcb3660'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
