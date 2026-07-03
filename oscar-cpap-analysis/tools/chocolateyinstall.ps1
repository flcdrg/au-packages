$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'OSCAR'
  fileType      = 'exe'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  
  validExitCodes= @(0) #please insert other valid exit codes here
  url64bit      = 'https://www.sleepfiles.com/OSCAR/2.0.1/OSCAR-2.0.1-Win64.exe'
  checksum64    = '4c55754016411402506e813ee20eabb5fc2f2c01350160102799f7b97c8fcbda'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
