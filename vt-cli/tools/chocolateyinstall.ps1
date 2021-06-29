$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/VirusTotal/vt-cli/releases/download/0.9.6/Windows32.zip'
$url64      = 'https://github.com/VirusTotal/vt-cli/releases/download/0.9.6/Windows64.zip'
$checksum   = '1B858DDE065C95C94AF5735717B19FEA0A2901827B9239E2248034830CCD0EE9'
$checksum64 = 'D07AE25993FB21E439A05BAB33899228CDDF731147D3A3C0865E4643751C8685'

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
