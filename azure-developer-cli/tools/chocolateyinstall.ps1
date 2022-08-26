$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://github.com/Azure/azure-dev/releases/download/azure-dev-cli_0.1.0-beta.5/azd-windows-amd64.zip'
$checksum      = 'a4fa2fce8bf289d4c95d5f6c961d353903bbe15ddf96ac437cf47c5f3e99b82c'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url

  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
Install-BinFile -Name 'azd' -path $toolsDir\azd-windows-amd64.exe
