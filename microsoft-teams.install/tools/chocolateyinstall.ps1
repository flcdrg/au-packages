$ErrorActionPreference = 'Stop';

$packageName= 'microsoft-teams.install'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32      = 'https://statics.teams.cdn.office.net/production-windows/1.3.00.26064/Teams_windows.msi'
$url64      = 'https://statics.teams.cdn.office.net/production-windows-x64/1.3.00.26064/Teams_windows_x64.msi'
$checksum32 = 'ac2c58703f0cc3fecdbdb45c16d3d6e455e3180595c25cb92acae67ef9404566'
$checksum64 = '5740e2eaf99b6022399d04cb654ad8efd332c84051801851b7c80730df7636bd'

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

Install-ChocolateyPackage @packageArgs
