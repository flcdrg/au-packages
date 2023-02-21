$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/VirusTotal/vt-cli/releases/download/0.11.0/Windows32.zip'
$url64      = 'https://github.com/VirusTotal/vt-cli/releases/download/0.11.0/Windows64.zip'
$checksum   = '035f9e3fa268748e7064e647bdefde2c137594901916e278cccdef39ab53b3bf'
$checksum64 = 'a83ce330280a1d4206567cd657ff5849344db5505e86019d0ecbc47aa16de3b7'

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
