$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'OSCAR'
  fileType      = 'exe'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  
  validExitCodes= @(0) #please insert other valid exit codes here
  url           = "https://www.apneaboard.com/OSCAR/1.5.3/OSCAR-1.5.3-Win32.exe"
  checksum      = '3BB7540B2E0062AD406B4A05CAC22D203121E733C5404A40C61F58B8C3FDE0A8'
  checksumType  = 'sha256'
  url64bit      = "https://www.apneaboard.com/OSCAR/1.5.3/OSCAR-1.5.3-Win64.exe"
  checksum64    = '5FB2FC71AB20D1EB539509E1F57C76C9A8D9266CB9EDEE51930A076CF2874EC6'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
