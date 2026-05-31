$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$checksum = 'F5A6558D483C64F1051D0CC9E523D9CCE0DCB3E9CA0CDAD8234D4749CC3C39AB'
$url = 'https://download.red-gate.com/installers/DotNETDeveloperBundle/2026-05-29/DotNETDeveloperBundle.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'exe'
  silentArgs    = "/IAgreeToTheEULA"
  validExitCodes= @(0)
  url           = $url
  checksum      = $checksum
  checksumType  = 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
