$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'WiFiman Desktop'
  fileType      = 'exe'
  silentArgs    = "/S"
  validExitCodes= @(0)
  url64bit      = "https://desktop.wifiman.com/wifiman-desktop-1.1.3-amd64.exe"
  checksum64    = 'B7FA21C4BA58BEFF6740927FC527307057FCE5CDA898A91DB3FE21EF344B2305'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
