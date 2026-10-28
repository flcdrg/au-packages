$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'OSCAR'
  fileType      = 'exe'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  
  validExitCodes= @(0) #please insert other valid exit codes here
  url64bit      = 'https://www.sleepfiles.com/OSCAR/2.1/OSCAR-2.1.0-Win64.exe'
  checksum64    = '01E7494E4589E4CB3DE7172C609F923F10E64A4D1C4FC6A2ACE20428998883B5'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
