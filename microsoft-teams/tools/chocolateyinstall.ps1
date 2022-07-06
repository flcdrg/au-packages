$ErrorActionPreference = 'Stop';

$packageName= 'microsoft-teams'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32      = 'https://statics.teams.cdn.office.net/production-windows/1.5.00.17656/TeamsSetup.exe'
$url64      = 'https://statics.teams.cdn.office.net/production-windows-x64/1.5.00.17656/Teams_windows_x64.exe'
$checksum32 = '9665f89874413f786db1d851f404a72255e671a9c21b009a1e629b6ca04a80ef'
$checksum64 = '941753dab32433b0383078c1b889fc380ca8ac1d576d2a5b49bf9912a7404cfd'

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
