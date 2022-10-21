$ErrorActionPreference = 'Stop';

$packageName= 'lenovo-thinkvantage-system-update'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.lenovo.com/pccbbs/thinkvantage_en/system_update_5.07.0140.exe'
$checksum   = '1fa965f7e072bd99528f7ac10866834d79852e0baab57b89ec727aff3b61fad4'

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
