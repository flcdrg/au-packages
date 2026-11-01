$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'OSCAR'
  fileType      = 'exe'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  
  validExitCodes= @(0) #please insert other valid exit codes here
  url64bit      = 'https://www.sleepfiles.com/OSCAR/2.1.1/OSCAR-2.1.1-Win64.exe'
  checksum64    = '8756c7d4732a82a6ad88e5b08afc6c987e103d3ffac6e18bd5f83b1d6dfee0b2'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
