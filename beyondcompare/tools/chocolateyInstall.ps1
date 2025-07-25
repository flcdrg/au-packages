$ErrorActionPreference = 'Stop'

$urlBase = "https://www.scootersoftware.com/files"

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
$version = '5.1.2.31185'

# Install for all users by default
if ($pp["CurrentUser"]) {
    $installMode = "/CURRENTUSER"
} else {
    $installMode = "/ALLUSERS"
}

$packageArgs = @{
  packageName   = 'beyondcompare'
  fileType      = 'exe'
  url           = '' # this gets set below
  silentArgs = "/SP- /VERYSILENT /NORESTART $InstallMode"
  checksum      = '' # this gets set below
  checksumType  = 'sha256'
}

$checksumde = '84666d9069ffcf7a7ecbd249a88eba9b95a63469039c428d82f588461e9fd915'
$checksumfr = '0f1dbd3b036d68cb3a1954ddc7e716d128b4ff6493eff9044f0e8e379a9931c4'
$checksumjp = '39bc5ebd89ec1609c5aa713f25c3d3614ab2de18e3068238b88ee5a023d3f924'
$checksumzh = '6f5c7f8aa9f262902f4ef66afc65399dfb29613e44f859bee93e521d9efbfc44'
$checksum = 'fdfa87d53640b59f9e16e3a0952ebad3f9b787788beaa656a1a00c64d48f5ca2'

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
