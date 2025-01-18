$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://s3.amazonaws.com/downloads.mirthcorp.com/connect/4.5.2.b363/mirthconnect-4.5.2.b363-windows-x32.exe'
$url64      = 'https://s3.amazonaws.com/downloads.mirthcorp.com/connect/4.5.2.b363/mirthconnect-4.5.2.b363-windows-x64.exe'
$checksum   = '3ddedb8b4bfc4a349ac12b87a6b5dcb24337126366cbd47594cf59f1916e9483'
$checksum64 = '69bb832d56f28c2c840e523efa4d7c72d47cd0b2bcd2babed16abe41e4d1a535'

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
