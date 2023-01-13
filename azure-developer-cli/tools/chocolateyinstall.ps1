$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://github.com/Azure/azure-dev/releases/download/azure-dev-cli_0.5.0-beta.2/azd-windows-amd64.zip'
$checksum      = 'ce0a0d3633220d10b8a9334adea108e955497aa5716f2f1b556be665f25f31b3'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url

  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
Install-BinFile -Name 'azd' -path $toolsDir\azd-windows-amd64.exe
