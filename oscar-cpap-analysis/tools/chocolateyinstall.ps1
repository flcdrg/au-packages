$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'OSCAR'
  fileType      = 'exe'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  
  validExitCodes= @(0) #please insert other valid exit codes here
  url           = 'https://www.sleepfiles.com/OSCAR/1.7.1/OSCAR-1.7.1-Win32-Qt5.exe'
  checksum      = '3b47b48334fe6670f9b43849a24d277c87ff4c74727bc312528c1727ecb99acc'
  checksumType  = 'sha256'
  url64bit      = 'https://www.sleepfiles.com/OSCAR/1.7.1/OSCAR-1.7.1-Win64-Qt5.exe'
  checksum64    = '3bb822fe7a1b9195babc9f879fc4b24645fec6d3a52ad93cd0ff07aabe724c7c'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
