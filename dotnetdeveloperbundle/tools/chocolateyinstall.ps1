$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$checksum = '1CFAB41BF75F8FC473438C977668A73B12A52042C428196A4CF31BD5F9B5F481'
$url = 'https://download.red-gate.com/installers/DotNETDeveloperBundle/2025-12-04/DotNETDeveloperBundle.exe'

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
