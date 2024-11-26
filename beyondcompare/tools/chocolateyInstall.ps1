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
$version = '5.0.4.30422'

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

$checksumde = '14d3991e9f659c8d3a2d8e1a7995746b027d2229909215638933043e89a4260a'
$checksumfr = '749d7a8d0d4acb8fdaad764bb6f58dd9dee85d03e219e2681dc0942a72abbaba'
$checksumjp = '6677d5b31ba14f98489996eb2f64c7b20a12fac1262b5d4adcc50d6885576c14'
$checksumzh = '6c12342619e0224c7e256543df3804f0f6001a20811929c0ddee790040a9404d'
$checksum = 'd74892601a50514b5636e27d4be4d3ac38597f2f6c7c7b6b5b169a48ffa1f341'

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
