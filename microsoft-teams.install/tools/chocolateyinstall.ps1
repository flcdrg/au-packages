$ErrorActionPreference = 'Stop';

$packageName= 'microsoft-teams.install'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32      = 'https://statics.teams.cdn.office.net/production-windows/1.4.00.8872/Teams_windows.msi'
$url64      = 'https://statics.teams.cdn.office.net/production-windows-x64/1.4.00.8872/Teams_windows_x64.msi'
$checksum32 = '54d96287f8147ca3031e49714fce0b2bcabdebcda35ff610bc7b7dc2d343af55'
$checksum64 = '022196f6058cc50edb5425a7b9bbcaf5956825e0e5c84b75260973574d104749'

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
}

Install-ChocolateyPackage @packageArgs
