$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$checksum = '1B3DF681DFCA4CDE170952AFB7E9591C82DAC3109C7CAE299A3C0091554308BB'
$url = 'https://download.red-gate.com/installers/SQLSearch/2026-10-13/SQLSearch.exe'

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
