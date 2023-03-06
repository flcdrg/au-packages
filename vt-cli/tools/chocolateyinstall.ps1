$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/VirusTotal/vt-cli/releases/download/0.12.0/Windows32.zip'
$url64      = 'https://github.com/VirusTotal/vt-cli/releases/download/0.12.0/Windows64.zip'
$checksum   = 'bfc801f833c1edd1bf1ad85dd94df7f56e0586713e9a18c983a105910f82cae7'
$checksum64 = '8f007260db64dea232a4e77ba9c9cb9092f8f0d864c936658a9eb7829dda40b9'

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
