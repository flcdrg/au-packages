$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/VirusTotal/vt-cli/releases/download/0.9.7/Windows32.zip'
$url64      = 'https://github.com/VirusTotal/vt-cli/releases/download/0.9.7/Windows64.zip'
$checksum   = 'fc0f5da67fbec70b9d421443964994e5cb3f04ea78ccf5208d39347faab39a0d'
$checksum64 = 'ce1536ec2fa21c29f8d98c98cb095272233dff0d9a9648f73c52520eb11c2ec1'

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
