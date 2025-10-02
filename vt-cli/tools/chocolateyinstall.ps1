$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/VirusTotal/vt-cli/releases/download/1.2.0/Windows32.zip'
$url64      = 'https://github.com/VirusTotal/vt-cli/releases/download/1.2.0/Windows64.zip'
$checksum   = '80309c8ef9a446b901578f2be33f5cd420516ecae8233dcea38b07e470a9d629'
$checksum64 = 'f95cde94fe7146ea9712d1ccad9ba9681505e92eb474d0c3e7f85a5f044963f8'

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
