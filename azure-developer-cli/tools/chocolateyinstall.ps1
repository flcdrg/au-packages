$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://github.com/Azure/azure-dev/releases/download/azure-dev-cli_0.2.0-beta.2/azd-windows-amd64.zip'
$checksum      = '9aa854c8c0295f8d491e3eb4ce4792794cc4b2d58c548744bf04c87bbfe60536'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url

  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
Install-BinFile -Name 'azd' -path $toolsDir\azd-windows-amd64.exe
