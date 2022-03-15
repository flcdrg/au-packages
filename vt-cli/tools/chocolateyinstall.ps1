$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/VirusTotal/vt-cli/releases/download/0.10.1/Windows32.zip'
$url64      = 'https://github.com/VirusTotal/vt-cli/releases/download/0.10.1/Windows64.zip'
$checksum   = 'ce1ae0e01f0ae10d5dc62c4fa059f5b5273150b16b0cd1fc268c828df2ea8ed6'
$checksum64 = '85b36b3a16a68dabc0fc98395277ed62678439c3e3f9386a140087e00313437b'

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
