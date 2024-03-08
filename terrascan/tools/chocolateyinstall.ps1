$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'terrascan*'
  
  url           = 'https://github.com/tenable/terrascan/releases/download/v1.19.1/terrascan_1.19.1_Windows_i386.zip'
  checksum      = 'c1d1e87255dbafe48d05e77f539f150d71e64d12e47e7740eeea588b8b6837a1'
  checksumType  = 'sha256'
  url64bit      = 'https://github.com/tenable/terrascan/releases/download/v1.19.1/terrascan_1.19.1_Windows_x86_64.zip'
  checksum64    = '05de015a9cf4bcf471f69d6fadd016110764f83fd50929cf56dffc674fe0dd4f'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
