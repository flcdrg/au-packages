$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/VirusTotal/vt-cli/releases/download/0.11.1/Windows32.zip'
$url64      = 'https://github.com/VirusTotal/vt-cli/releases/download/0.11.1/Windows64.zip'
$checksum   = '1af3893b6f9ed5a7d3c3b7aa446c6ceaf59489192c75a4d87e4a7703896e3c06'
$checksum64 = '07cd133771cfae8cc4563117b61b4c813385076df0110a482256a61c991d20fb'

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
