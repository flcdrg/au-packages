$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/VirusTotal/vt-cli/releases/download/0.13.0/Windows32.zip'
$url64      = 'https://github.com/VirusTotal/vt-cli/releases/download/0.13.0/Windows64.zip'
$checksum   = '4a710121965feecd82c6579f73af07c887198364c4371435a98d5b01163d0677'
$checksum64 = '157f19d284858013c6c05c8de2dee2390755c07293e514220536906ccaa444e9'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url
  url64bit      = $url64
  softwareName  = 'vt-cli*'
  checksum      = $checksum
  checksumType  = 'sha256'
  checksum64    = $checksum64
  checksumType64= 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
