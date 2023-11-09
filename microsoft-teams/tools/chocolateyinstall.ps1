$ErrorActionPreference = 'Stop';

$packageName= 'microsoft-teams'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32      = 'https://statics.teams.cdn.office.net/production-windows/1.6.00.29964/TeamsSetup.exe'
$url64      = 'https://statics.teams.cdn.office.net/production-windows-x64/1.6.00.29964/Teams_windows_x64.exe'
$checksum32 = '10def90e61968ad95deff7f3b2ba7c0a79a94df6e22d5aba72dd5299b5fb0837'
$checksum64 = '3ba4991617a7511e1a5907138f30ea4d3f393520d45b7adc55a099c56f0afa26'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url32
  url64bit      = $url64

  softwareName  = 'microsoft-teams*'

  checksum      = $checksum32
  checksumType  = 'sha256'
  checksum64    = $checksum64
  checksumType64= 'sha256'

  silentArgs    = "-s"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
