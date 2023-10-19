$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://s3.amazonaws.com/downloads.mirthcorp.com/connect/4.4.1.b310/mirthconnect-4.4.1.b310-windows-x32.exe'
$url64      = 'https://s3.amazonaws.com/downloads.mirthcorp.com/connect/4.4.1.b310/mirthconnect-4.4.1.b310-windows-x64.exe'
$checksum   = '385da84be8e14c0b07508e82f28517283020fc8e316e0d642ec9a2e3fc141826'
$checksum64 = '218a40358c48952a958ead0121637ef38302fed961d67d530139d7a55335ca31'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url
  url64bit      = $url64

  softwareName  = 'Mirth Connect *'

  checksum      = $checksum
  checksumType  = 'sha256'
  checksum64    = $checksum64
  checksumType64= 'sha256'

  # OTHERS
  silentArgs   = "-q -console -varfile `"$($toolsDir)\response.varfile`""
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
