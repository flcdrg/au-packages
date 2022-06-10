$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'sourcemonitor*'
  fileType      = 'exe'
  silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"
  
  validExitCodes= @(0)
  url           = "https://www.derpaul.net/SourceMonitor/3.5.16.62/SMSetupV3516.exe"
  checksum      = 'D9605621F277FD477A1A09F0980D1A7AD6D50CFDEA71D4DAD162DA4884913F29'
  checksumType  = 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs 