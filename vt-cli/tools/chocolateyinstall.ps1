$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/VirusTotal/vt-cli/releases/download/0.10.3/Windows32.zip'
$url64      = 'https://github.com/VirusTotal/vt-cli/releases/download/0.10.3/Windows64.zip'
$checksum   = 'e3a4900287501f1dab488abce6287c20aef27e6ddfd9961019a6b300ab50476e'
$checksum64 = 'd4944611c446a9e67e7065b9bd2c04434240b60809e071ef9e153c89a2fa52c4'

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
