$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'OSCAR'
  fileType      = 'exe'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  
  validExitCodes= @(0) #please insert other valid exit codes here
  url           = "https://www.sleepfiles.com/OSCAR/1.7.0/OSCAR-1.7.0-Win32-Qt5.exe"
  checksum      = 'B6C628DDB5A5A6B297CBB382C7F0035530ACE1CF1880455A8F68CFA21B5A89C2'
  checksumType  = 'sha256'
  url64bit      = "https://www.sleepfiles.com/OSCAR/1.7.0/OSCAR-1.7.0-Win64-Qt5.exe"
  checksum64    = '2766605DE1A29C63C7248831851A258089A1F44A30179361B5A91238F1003629'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
