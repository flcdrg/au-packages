$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'oscar-cpap-analysis*'
  fileType      = 'exe'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  
  validExitCodes= @(0) #please insert other valid exit codes here
  url           = "https://www.apneaboard.com/OSCAR/OSCAR-1.3.1-Win32.exe"
  checksum      = 'E6CCD57729521B3452CAC6F10584DADEB29B9AF2F9D2A178897530F2A8DAC370'
  checksumType  = 'sha256'
  url64bit      = "https://www.apneaboard.com/OSCAR/OSCAR-1.3.1-Win64.exe"
  checksum64    = '8F393F30C051B320E725F25EFEBB31D59F0ED3B0F35EE02BB480658CF3DF9A75'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
