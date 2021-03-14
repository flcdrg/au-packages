$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'oscar-cpap-analysis*'
  fileType      = 'exe'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  
  validExitCodes= @(0) #please insert other valid exit codes here
  url           = "https://www.apneaboard.com/OSCAR/OSCAR-1.2.0-Win32.exe"
  checksum      = 'D85758031D51DAB7FD72B46D7C76FB574C357DDD00AAE7FC51F828725B841FC1'
  checksumType  = 'sha256'
  url64bit      = "https://www.apneaboard.com/OSCAR/OSCAR-1.2.0-Win64.exe"
  checksum64    = 'F6968F75FC8C398A6A26BAED84AA5F14358F284ED8FECC00797906FFABFF1EC2'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
