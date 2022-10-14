$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/VirusTotal/vt-cli/releases/download/0.10.4/Windows32.zip'
$url64      = 'https://github.com/VirusTotal/vt-cli/releases/download/0.10.4/Windows64.zip'
$checksum   = 'aed67b753f5ede757d36aa5c92da5c45ef0388d8ae935dabeb5df90b1816e915'
$checksum64 = '97ddbc169da118f6416cb4269b4c87fa44023c7b66e98cc60b7953bea45d0303'

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
