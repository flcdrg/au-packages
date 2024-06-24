$ErrorActionPreference = 'STOP';

$packageName= 'azure-functions-core-tools'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url_arm64      = 'https://functionscdn.azureedge.net/public/4.0.5858/Azure.Functions.Cli.win-arm64.4.0.5858.zip'
$url_x86        = 'https://functionscdn.azureedge.net/public/4.0.5858/Azure.Functions.Cli.win-x86.4.0.5858.zip'
$url_x64        = 'https://functionscdn.azureedge.net/public/4.0.5858/Azure.Functions.Cli.win-x64.4.0.5858.zip'
$checksum_arm64 = '2632B8F4150FCB4C6CA667C51C4F1E2F9B1DCE0D46BD15656A12447486E6567DA2657F8E9EC69466DFB1DB13884887151FF795B5DA35CEF4B00C911065AC3A2B'
$checksum_x86   = '4ED3E01DE76FCE5AA2C1B3DAE31FA549BBAB34008BC890A110D860075136D1B0A5BADCFD46550205FF04EA08E8148A7D620722E064A92F6F0AA6D52380AFEACE'
$checksum_x64   = 'FECE275A50762E27815A92DD3B1C92925F8459B06765D7F2384ED70F584B8DB857BE06EE1A63E60F6025D9A42572F9DFBBD04818302A719341B5F7403CC3B2F8'

# Get-PackageParameters returns a hash table array of values
$pp = Get-PackageParameters
# If specifically asked for x64 or arm64, we use that
if ($pp.ContainsKey('x64'))
{
  $url = $url_x64
  $checksum = $checksum_x64
}
elseif ($pp.ContainsKey('arm64'))
{
  $url =  $url_arm64
  $checksum = $checksum_arm64
}
else
{
  # By default, we want the x86 installer
  $url = $url_x86
  $checksum = $checksum_x86
}

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  url           = $url
  checksum      = $checksum
  checksumType  = 'SHA512'
}

Install-ChocolateyZipPackage @packageArgs

