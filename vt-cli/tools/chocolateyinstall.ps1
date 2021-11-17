$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/VirusTotal/vt-cli/releases/download/0.9.8/Windows32.zip'
$url64      = 'https://github.com/VirusTotal/vt-cli/releases/download/0.9.8/Windows64.zip'
$checksum   = '89086b67da37f28c3d192c29d2e861024d4f0b0bed1d0d6d32a084a13f3f3db8'
$checksum64 = 'a2fc2e5d3f6f3d3c85d60c14ba4c23c4c7971ed0e128863612c2101880769eb6'

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
