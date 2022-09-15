$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://github.com/Azure/azure-dev/releases/download/azure-dev-cli_0.2.0-beta.1/azd-windows-amd64.zip'
$checksum      = '5e1811ca5c1e1e3c9242e364ad81ba923daef0f8035b9632a9896b3ad3c629bc'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url

  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
Install-BinFile -Name 'azd' -path $toolsDir\azd-windows-amd64.exe
