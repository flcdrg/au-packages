$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/VirusTotal/vt-cli/releases/download/1.0.0/Windows32.zip'
$url64      = 'https://github.com/VirusTotal/vt-cli/releases/download/1.0.0/Windows64.zip'
$checksum   = '4285e83f23b4ad90937a4e2fe94c2fd26f0d03f82af5aa9a2770928df9e25ae5'
$checksum64 = '694273d1e34eb359ff966e71cfabed6f002d4c16614d20123dd53028d281d3b3'

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
