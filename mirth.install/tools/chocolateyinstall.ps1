$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://s3.amazonaws.com/downloads.mirthcorp.com/connect/4.4.0.b2948/mirthconnect-4.4.0.b2948-windows-x32.exe'
$url64      = 'https://s3.amazonaws.com/downloads.mirthcorp.com/connect/4.4.0.b2948/mirthconnect-4.4.0.b2948-windows-x64.exe'
$checksum   = 'e94677be0714a67f1cabd470a1b83276a66d7150747c51203947686968a9a8e1'
$checksum64 = '34223057e0f01a2ce100197e0c3d3d908723df882a2196f683610daa00eef8c0'

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
  silentArgs   = "-q -console -varfile $($toolsDir)\response.varfile"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
