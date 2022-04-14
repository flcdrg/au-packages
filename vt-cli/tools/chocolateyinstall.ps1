$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/VirusTotal/vt-cli/releases/download/0.10.2/Windows32.zip'
$url64      = 'https://github.com/VirusTotal/vt-cli/releases/download/0.10.2/Windows64.zip'
$checksum   = '7d5de99f77d95a2d9a52062e0af1d71f98d1ce9d3f21c909a99b2d0a5ef58215'
$checksum64 = '03c20eec8b9fea9bc455cc70c6703042fe2fd471a02743ab7a183d28ae5f1ffa'

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
