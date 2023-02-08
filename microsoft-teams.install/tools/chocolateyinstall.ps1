$ErrorActionPreference = 'Stop';

$packageName= 'microsoft-teams.install'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32      = 'https://statics.teams.cdn.office.net/production-windows/1.6.00.1381/Teams_windows.msi'
$url64      = 'https://statics.teams.cdn.office.net/production-windows-x64/1.6.00.1381/Teams_windows_x64.msi'
$checksum32 = '1b5295cdc497a2c8eaa36000fabff925b0e9093ea437876b5060bb165a47ac12'
$checksum64 = '8282eed2a2e9783655d3677b64172c2b8cb3cac371c96ac42502f1fa9730135e'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url32
  url64bit      = $url64

  softwareName  = 'Teams Machine-Wide Installer'

  checksum      = $checksum32
  checksumType  = 'sha256'
  checksum64    = $checksum64
  checksumType64= 'sha256'

  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
  validExitCodes= @(0, 3010, 1641)
}

$pp = Get-PackageParameters

if ($pp['NoAutoStart']) {
  $packageArgs.silentArgs += ' OPTIONS="noAutoStart=true"'
}

if ($pp['AllUsers']) {
  $packageArgs.silentArgs += ' ALLUSERS=1'
}

#Machine Wide installaer VDI/WVD
if ($pp['AllUser']) {
  $packageArgs.silentArgs += ' ALLUSER=1'
  reg add "HKLM\SOFTWARE\Microsoft\Teams" /v IsWVDEnvironment /t REG_DWORD /d 1 /f
}

Install-ChocolateyPackage @packageArgs
