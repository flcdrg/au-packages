$ErrorActionPreference = 'STOP';

$packageName = 'azure-functions-core-tools'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url_arm64 = 'https://functionscdn.azureedge.net/public/4.0.5858/Azure.Functions.Cli.win-arm64.4.0.5858.zip'
$url_x86 = 'https://github.com/Azure/azure-functions-core-tools/releases/download/4.0.5858/Azure.Functions.Cli.win-x86.4.0.5858.zip'
$url_x64 = 'https://github.com/Azure/azure-functions-core-tools/releases/download/4.0.5858/Azure.Functions.Cli.win-x64.4.0.5858.zip'
$checksum_arm64 = '2632B8F4150FCB4C6CA667C51C4F1E2F9B1DCE0D46BD15656A12447486E6567DA2657F8E9EC69466DFB1DB13884887151FF795B5DA35CEF4B00C911065AC3A2B'
$checksum_x86 = '448ec30de82f04caebd46f238280c4d104ffaf4b5da97a9bd6d24a391ef831ce'
$checksum_x64 = '88441e477e9d48162253c259a6d0625b0a8539fbc17228f739e8d9309d0ef9ec'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  url           = $url_x86
  url64         = $url_x64
  checksum      = $checksum_x86
  checksum64    = $checksum_x64
  checksumType  = 'SHA512'
}

Install-ChocolateyZipPackage @packageArgs
