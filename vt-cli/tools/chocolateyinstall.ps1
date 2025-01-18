$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/VirusTotal/vt-cli/releases/download/1.0.1/Windows32.zip'
$url64      = 'https://github.com/VirusTotal/vt-cli/releases/download/1.0.1/Windows64.zip'
$checksum   = '45c2aeb98fae8664f2b25b8db8322e87de0578092581d6e941cfb2742e484368'
$checksum64 = 'dd08ed6653c2e22fa085e651e624a2554535dcfa1483b4f3610698f4295bb8c9'

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
