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
$version = '5.0.0.29773'

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

$checksumde = '5dac39c109d3a117bf0734a7b2921f54aa93202cc61fbe0e7aa1f0c7f4ea8ba0'
$checksumfr = 'c2cd0bb710d82e84636d5c629743c3e33737e4d177be6e0fbeb93dda34f1cb75'
$checksumjp = '93579fd8bc6107e52906e46cbb17e1950da51d547c0d2e85babddfe61c068c88'
$checksumzh = '4bc4c6d3ec429c767ab904afb5a89ecd841162085c1198654e396a13a97746b0'
$checksum = 'b41fbacd787bcf1a743b9c1b4cdd6e1dfc0d12e44e851db2df2387ccd38e376a'

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
