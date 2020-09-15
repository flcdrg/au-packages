$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://s3.amazonaws.com/downloads.mirthcorp.com/connect/3.9.1.b263/mirthconnect-3.9.1.b263-windows.exe'
$url64      = 'https://s3.amazonaws.com/downloads.mirthcorp.com/connect/3.9.1.b263/mirthconnect-3.9.1.b263-windows-x64.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url
  url64bit      = $url64

  softwareName  = 'Mirth Connect *'

  checksum      = '632e5ecab89dcacebf777b38ec2fd63f280550539082572b6de4ce30f304e360'
  checksumType  = 'sha256'
  checksum64    = 'a90fd803a88c4dae266aac0ddfa48d1da538cf7c622a5fd459ba217549a5a641'
  checksumType64= 'sha256'

  # OTHERS
  silentArgs   = "-q -console -varfile $($toolsDir)\response.varfile"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
