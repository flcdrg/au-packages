$ErrorActionPreference = 'Stop';

$packageName= 'microsoft-teams'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32      = 'https://statics.teams.cdn.office.net/production-windows/1.4.00.26376/TeamsSetup.exe'
$url64      = 'https://statics.teams.cdn.office.net/production-windows-x64/1.4.00.26376/Teams_windows_x64.exe'
$checksum32 = '4b4319fbf77260fb5b55248790657e145b0e479013144bc35a71a497d7be0542'
$checksum64 = '7b12326fd39c633143cc6720bc09c4a1b283337fcf781f738b3c8651dfe1b9d1'

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
