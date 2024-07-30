$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://s3.amazonaws.com/downloads.mirthcorp.com/connect/4.5.1.b332/mirthconnect-4.5.1.b332-windows-x32.exe'
$url64      = 'https://s3.amazonaws.com/downloads.mirthcorp.com/connect/4.5.1.b332/mirthconnect-4.5.1.b332-windows-x64.exe'
$checksum   = 'b07683ed590d831156733b75bfce2d3eeea5a3ce34d527e4145078d5e7ee5c81'
$checksum64 = '09d6f4d42e3aab5b32a0ac6112f504dca5f0cf18f6eadaa375d1d3425ef1c13d'

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
