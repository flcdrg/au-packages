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
$version = '5.1.1.31157'

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

$checksumde = '73f371a2c82a9144fc3d59632f86ea1d835d3f5990808e147d1d4367704e834c'
$checksumfr = '034834f5a6e02f4bb9206dd5edba48efaadd6b0fde6cf1605ddaff9678f0deb5'
$checksumjp = '27c6d27f51b431f97004998a13d6c1f24c0d88c6bbe9bba897265d04f1b105a5'
$checksumzh = '1e8cb445050507fcc294b302cc7b730ba544a7970b1a628ca71f1cdd5b2dbc5e'
$checksum = '695562e166339c8748d87342108c7c631995c192115dd0c102661d4c749f8e6a'

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
