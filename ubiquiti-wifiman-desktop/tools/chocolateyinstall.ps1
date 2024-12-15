$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'ubiquiti-wifiman-desktop*'
  fileType      = 'exe'
  silentArgs    = "/s"
  validExitCodes= @(0)
  url64bit      = "https://desktop.wifiman.com/wifiman-desktop-1.1.0-amd64.exe"
  checksum64    = 'CB22CC3EBD21BADC64524452B5FD54A19AF5010EFB52D1EB0EAF319A3D3D961F'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
