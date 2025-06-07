$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/VirusTotal/vt-cli/releases/download/1.1.1/Windows32.zip'
$url64      = 'https://github.com/VirusTotal/vt-cli/releases/download/1.1.1/Windows64.zip'
$checksum   = '5bcd4e85e9925f80bd1e02e7eaab50ed37c1999cfe59d144ab7c5b5a1a534b4e'
$checksum64 = '469b7e7f4d5ccfce12a0576a82822ecd431e852052517af28acf67d93609fd14'

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
