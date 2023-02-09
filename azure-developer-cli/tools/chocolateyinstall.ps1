$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://github.com/Azure/azure-dev/releases/download/azure-dev-cli_0.6.0-beta.1/azd-windows-amd64.zip'
$checksum      = '5828a8fc9786a7b223ed8be6cc079195b4213c8130f29b52fd3f2d9823716ba7'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url

  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
Install-BinFile -Name 'azd' -path $toolsDir\azd-windows-amd64.exe
