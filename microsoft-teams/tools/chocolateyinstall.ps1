$ErrorActionPreference = 'Stop';

$packageName= 'microsoft-teams'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32      = 'https://statics.teams.cdn.office.net/production-windows/1.3.00.34662/Teams_windows.exe'
$url64      = 'https://statics.teams.cdn.office.net/production-windows-x64/1.3.00.34662/Teams_windows_x64.exe'
$checksum32 = '403733228fb77e74e7e7350cc1da7834862f3c337893d18ad378cf9cb48bb563'
$checksum64 = 'cdb41bfbb8107048f4fcdfe230ce9faf138635d87284206ec6c10624533bf1e9'

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
