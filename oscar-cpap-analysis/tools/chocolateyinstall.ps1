$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'OSCAR'
  fileType      = 'exe'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  
  validExitCodes= @(0) #please insert other valid exit codes here
  url           = "https://www.apneaboard.com/OSCAR/1.6.0/OSCAR-1.6.0-Win32.exe"
  checksum      = '1D250674ECD891B3DC22F60BFE879F6971CAA3ACDF71D73542F90145ABF29F3B'
  checksumType  = 'sha256'
  url64bit      = "https://www.apneaboard.com/OSCAR/1.6.0/OSCAR-1.6.0-Win64.exe"
  checksum64    = '148E6C2DE32EF51B11A53739B70C8ED5026C9D68CE137DA4ACCC8EC213B05629'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
