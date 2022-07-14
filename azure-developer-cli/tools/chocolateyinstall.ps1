$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://azure-dev.azureedge.net/azd/standalone/release/0.1.0-beta.2/azd-windows-amd64.zip'
$checksum      = '710E78224DCEBB52438C7C4938BFDFBB5EBAA2C965E52D5D2B0959FB611F3557'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url

  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
Install-BinFile -Name 'azd' -path $toolsDir\azd-windows-amd64.exe