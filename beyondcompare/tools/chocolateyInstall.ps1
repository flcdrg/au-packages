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
$version = '4.4.7.28397'

$packageArgs = @{
  packageName   = 'beyondcompare'
  fileType      = 'exe'
  url           = $url
  silentArgs = '/SP- /VERYSILENT /NORESTART'

  checksum      = ''
  checksumType  = 'sha256'
}

$checksumde = 'e3aba498539e9872231b3c3960074b9396d48f763104ce2485b40b5c855223a6'
$checksumfr = '9e2f5bf0fc85758a75af18ab5b3d884869e4cf2cbed27770f3abce5fc158c6c2'
$checksumjp = 'ecc7a88b4b821da58cd463e85fdcb2a1c82bfa31b31a1df9b8b69112503c23da'
$checksumzh = '9da5bab97eb3d97eeabb1eed85ec1a03ea5d28021f558d5aaefc8ae48aa2bf00'
$checksum = '5b14f35bf4219fdcc138a4a6ed8f20605d455027a94a50ab37db64e53153d141'

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
