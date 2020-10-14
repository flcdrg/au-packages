$ErrorActionPreference = 'Stop';

$packageName= 'microsoft-teams'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32      = 'https://statics.teams.cdn.office.net/production-windows/1.3.00.26064/Teams_windows.exe'
$url64      = 'https://statics.teams.cdn.office.net/production-windows-x64/1.3.00.26064/Teams_windows_x64.exe'
$checksum32 = 'b4c5b3fc461336091505c72a8d5fa825b896b866db2fa87e2390e328a85a2b58'
$checksum64 = 'c302f8d223cec2af255b1dd896a3cf0da1aaaf1d8b4ce5dae59be8de9daead44'

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
