$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$checksum = '8039C8E965DC05914931F806F9B0D8FE89D34353679C10C119C4A54C1AD0BEBB'
$url = 'https://download.red-gate.com/installers/SQLSearch/2026-08-27/SQLSearch.exe'

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
