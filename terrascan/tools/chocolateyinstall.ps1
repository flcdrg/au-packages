$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'terrascan*'
  
  url           = 'https://github.com/tenable/terrascan/releases/download/v1.18.12/terrascan_1.18.12_Windows_i386.zip'
  checksum      = '82eb64d48a137b68620b82a68b76daf19b4b99fb1399093192e6331b77154264'
  checksumType  = 'sha256'
  url64bit      = 'https://github.com/tenable/terrascan/releases/download/v1.18.12/terrascan_1.18.12_Windows_x86_64.zip'
  checksum64    = '7e413e264e18794fd56a903ce10305e1af07ddffdba9877d9209412e00180044'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
