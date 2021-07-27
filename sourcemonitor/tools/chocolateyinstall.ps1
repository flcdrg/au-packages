$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'sourcemonitor*'
  fileType      = 'exe'
  silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"
  
  validExitCodes= @(0)
  url           = "https://www.campwoodsw.com/SM/SMSetupV3516.exe"
  checksum      = 'CF242B8DFD90BDE704B34ADEBA7DD46B02685E62C98EBBACA8C6016A3CC41066'
  checksumType  = 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs 