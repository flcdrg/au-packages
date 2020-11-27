$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://s3.amazonaws.com/downloads.mirthcorp.com/connect/3.10.0.b2566/mirthconnect-3.10.0.b2566-windows.exe'
$url64      = 'https://s3.amazonaws.com/downloads.mirthcorp.com/connect/3.10.0.b2566/mirthconnect-3.10.0.b2566-windows-x64.exe'
$checksum   = '86f8f333b3faf745f4ae906483f17ede2d286ac4ad232d396e6fb49b42bcceb3'
$checksum64 = '290fc631bb42d777796522425f070c86f71673db1c9571bbb344ff6090702cc5'

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
