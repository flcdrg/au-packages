$ErrorActionPreference = 'Stop';

$packageName= 'microsoft-teams'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32      = 'https://statics.teams.cdn.office.net/production-windows/1.3.00.28779/Teams_windows.exe'
$url64      = 'https://statics.teams.cdn.office.net/production-windows-x64/1.3.00.28779/Teams_windows_x64.exe'
$checksum32 = '467ad3137810941c9765e262e6507a1a9c04b045adae36b15e5e60c76f36e6af'
$checksum64 = 'bcfa005ca2dd6a8d69495deed8e656b43f059822934a29e0979afe49bb30c77c'

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
