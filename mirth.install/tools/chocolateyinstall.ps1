$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://s3.amazonaws.com/downloads.mirthcorp.com/connect/3.10.1.b280/mirthconnect-3.10.1.b280-windows.exe'
$url64      = 'https://s3.amazonaws.com/downloads.mirthcorp.com/connect/3.10.1.b280/mirthconnect-3.10.1.b280-windows-x64.exe'
$checksum   = 'cd3e582ce6b9606dfb804d010ef065e7c632c99d3fa366f8ffeccdaad5e54b3d'
$checksum64 = '54db2d7956a17d24e9976ff9404ce99d81dc1451b1459092c1a71a240fab689b'

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
