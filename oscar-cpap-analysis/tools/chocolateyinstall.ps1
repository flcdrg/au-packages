$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'OSCAR'
  fileType      = 'exe'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  
  validExitCodes= @(0) #please insert other valid exit codes here
  url           = "https://www.apneaboard.com/OSCAR/OSCAR-1.5.0-Win32.exe"
  checksum      = 'AE298A414E99E36F99991F661AE0E192454B3D03A8D1C71D2C733E11B2C4C8F1'
  checksumType  = 'sha256'
  url64bit      = "https://www.apneaboard.com/OSCAR/OSCAR-1.5.0-Win64.exe"
  checksum64    = '72AC52F4F063948BB957FB7921E8A1A3C5BD11F8EECF9CC33B8D7384A927F7EB'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
