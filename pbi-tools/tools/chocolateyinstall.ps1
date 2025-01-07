$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url64 = 'https://github.com/pbi-tools/pbi-tools/releases/download/1.2.0/pbi-tools.1.2.0.zip'
$checksum64 = 'bca88abb9f30d17ee354a06e75eb3f6c6bdeeb9c98a46990e86978a52a3876b7'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'pbi-tools*'
  fileType      = 'zip'
  silentArgs   = ''

  validExitCodes= @(0)
  url64           = $url64
  checksum64      = $checksum64
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
