$ErrorActionPreference = 'Stop';

$packageName= 'microsoft-teams'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32      = 'https://statics.teams.cdn.office.net/production-windows/1.4.00.2879/Teams_windows.exe'
$url64      = 'https://statics.teams.cdn.office.net/production-windows-x64/1.4.00.2879/Teams_windows_x64.exe'
$checksum32 = 'e7626816248bcdc4aa5ab3d41d382e6888e0dd0c2b194201a7821edf9b484a7f'
$checksum64 = '6968540a0defd3c49187585d35fb3d449bc34d6d79016860200b6e204c75cf5e'

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
