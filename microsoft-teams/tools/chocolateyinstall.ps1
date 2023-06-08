$ErrorActionPreference = 'Stop';

$packageName= 'microsoft-teams'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32      = 'https://statics.teams.cdn.office.net/production-windows/1.6.00.12455/TeamsSetup.exe'
$url64      = 'https://statics.teams.cdn.office.net/production-windows-x64/1.6.00.12455/Teams_windows_x64.exe'
$checksum32 = '60f7cf85c520fcc72d87d9b0b8e4762f9adb12392f9be6cf90bf6d031b553464'
$checksum64 = '5d1841e46c869b04895d13f11ff74e02c2398601e6a3e42b696a73df658828cb'

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
