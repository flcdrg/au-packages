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
$version = '5.2.0.31950'

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

$checksumde = 'a6fad8f74abc39f48cbe3cf24503854d747c21771a7674a85a3a483b3f52c0e8'
$checksumfr = '63c58a245cd9e975bbda38d5bc581d114a3f48d98820d63c5582439f9053d6aa'
$checksumjp = '7ac1a728239989d9e01a3c89cb4fae14a4f02b33484fd45b0440592fe44c1254'
$checksumzh = '7047429892f37a13c8ee8f4730589fb51c10b91a3d82d3b793de9cd5ad0c020b'
$checksum = '0b2b60a44498912d3767609724d246ad6d4235110b01ca22b3bbb8bb5784c266'

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
