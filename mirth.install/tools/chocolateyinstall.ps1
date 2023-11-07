$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://s3.amazonaws.com/downloads.mirthcorp.com/connect/4.4.2.b326/mirthconnect-4.4.2.b326-windows-x32.exe'
$url64      = 'https://s3.amazonaws.com/downloads.mirthcorp.com/connect/4.4.2.b326/mirthconnect-4.4.2.b326-windows-x64.exe'
$checksum   = 'e01732bab9766e985156d05e38290dd3a6e3f5293e366d5878362c7e9ce2b5b0'
$checksum64 = '415fc52948df4d64296bf3b89b47379ee4766fabc0fc2db357c9b1698a45a83d'

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
