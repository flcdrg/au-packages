﻿$ErrorActionPreference = 'Stop';

$packageName= 'microsoft-teams.install'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32      = 'https://statics.teams.cdn.office.net/production-windows/1.8.00.6262/Teams_windows.msi'
$url64      = 'https://statics.teams.cdn.office.net/production-windows-x64/1.8.00.6262/Teams_windows_x64.msi'
$checksum32 = 'e9bcc8f04f536a29424a874dc8c10dfe04f9682f6f19b5f218041d50659c1aba'
$checksum64 = '5977ecb6ce94108831344dea99c4a6d2f281fc57e4c5e33ab538976c3ce5ce21'

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
