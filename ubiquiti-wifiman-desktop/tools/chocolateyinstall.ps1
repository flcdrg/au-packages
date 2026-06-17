$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'WiFiman Desktop'
  fileType      = 'exe'
  silentArgs    = "/S"
  validExitCodes= @(0)
  url64bit      = "https://desktop.wifiman.com/wifiman-desktop-1.2.8-amd64.exe"
  checksum64    = '7A6015C4E9EAB7D1A040518958D5FC4FD05A9A55087A94B13A0C9D689A28671A'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
