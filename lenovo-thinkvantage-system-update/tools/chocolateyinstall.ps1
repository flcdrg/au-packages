$ErrorActionPreference = 'Stop';

$packageName= 'lenovo-thinkvantage-system-update'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.lenovo.com/pccbbs/thinkvantage_en/system_update_5.07.0124.exe'
$checksum   = '2a8b418fa1f00096cdf5d80ac66a22e8a29ae23c20cdd2d79c9a41b11b7ee533'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url
  softwareName  = 'Lenovo System Update'
  checksum      = $checksum
  checksumType  = 'sha256'
  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
