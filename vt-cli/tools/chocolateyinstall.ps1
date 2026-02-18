$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/VirusTotal/vt-cli/releases/download/1.3.0/Windows32.zip'
$url64      = 'https://github.com/VirusTotal/vt-cli/releases/download/1.3.0/Windows64.zip'
$checksum   = 'c6767d20450aeaa84900bb2015b5477107eeac84191686c43147bf6fcef7d871'
$checksum64 = '48dd7e662a2a3334ed602a29ad6e0c81acbd8d46ab04cc1d12908e71c5d62a9f'

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
