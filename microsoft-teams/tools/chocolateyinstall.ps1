$ErrorActionPreference = 'Stop';

$packageName= 'microsoft-teams'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32      = 'https://statics.teams.cdn.office.net/production-windows/1.6.00.26474/TeamsSetup.exe'
$url64      = 'https://statics.teams.cdn.office.net/production-windows-x64/1.6.00.26474/Teams_windows_x64.exe'
$checksum32 = 'e93f61c7f47acd74d7ba812898ed038cf0942b9e4679966ad280de116f508ecc'
$checksum64 = 'ad564702bfb292d3c9be65b2adbcadfc0040b7b7ba7a605507e86767cdef45a8'

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
