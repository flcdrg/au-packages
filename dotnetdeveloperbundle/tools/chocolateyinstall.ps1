$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$checksum = '3C6FC3103989068AE84A2B920292059B263374883ECEDD940BB6054B713BFDDD'
$url = 'https://download.red-gate.com/installers/DotNETDeveloperBundle/2026-07-08/DotNETDeveloperBundle.exe'

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
