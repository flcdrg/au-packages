$ErrorActionPreference = 'Stop'

$urlBase = "https://www.scootersoftware.com"

$pp = Get-PackageParameters

if ($pp["LCID"]) {
    $LCID = $pp["LCID"]
} else {
    $LCID = (Get-UICulture).LCID
}

$german = @(3079,1031,5127,4103,2055)
$french = @(2060,11276,3084,9228,12300,1036,5132,13324,6156,14348,10252,4108,7180)
$japanese = @(17, 1041)
$chinese = @(2052)
$version = '4.4.5.27371'

$packageArgs = @{
  packageName   = 'beyondcompare'
  fileType      = 'exe'
  url           = $url
  silentArgs = '/SP- /VERYSILENT /NORESTART'

  checksum      = ''
  checksumType  = 'sha256'
}

$checksumde = 'df17331f4edcba31f04281fdd338f9b84eb8b0899b74d39fe59efeb02c3047eb'
$checksumfr = 'ad15cd58282a2ebf2659389376e3bfbd5ac1a209782050c7d5266e4a3e5cccca'
$checksumjp = '142cf9e2c9350627fc9f34feda1dca55f535ee4f5678e59062bf48cd81e35e72'
$checksumzh = '85a311dbe3d3645474142868cbb4c3f0d09834e181e14bb6d00f38aa778de2b9'
$checksum = '4f40961ad272ce7cb336dd0aa85737edb536501f8e069628db0375eec12d3928'

if ($german -contains $LCID)
{
    $packageArgs.url = "$urlBase/BCompare-de-$version.exe"
    $packageArgs.checksum = $checksumde
}
elseif ($french -contains $LCID)
{
    $packageArgs.url = "$urlBase/BCompare-fr-$version.exe"
    $packageArgs.checksum = $checksumfr
}
elseif ($japanese -contains $LCID)
{
    $packageArgs.url = "$urlBase/BCompare-jp-$version.exe"
    $packageArgs.checksum = $checksumjp
}
elseif ($chinese -contains $LCID) {
    $packageArgs.url = "$urlBase/BCompare-zh-$version.exe"
    $packageArgs.checksum = $checksumzh
}
else
{
    $packageArgs.url = "$urlBase/BCompare-$version.exe"
    $packageArgs.checksum = $checksum
}

Install-ChocolateyPackage @packageArgs
