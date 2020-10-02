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
$version = '4.3.7.25118'

$packageArgs = @{
  packageName   = 'beyondcompare'
  fileType      = 'exe'
  url           = $url
  silentArgs = '/SP- /VERYSILENT /NORESTART'

  checksum      = ''
  checksumType  = 'sha256'
}

$checksumde = 'b7aefbd3940123146cb423a50ba8ac7d58026e38e1fab05ff11eda8a96e8ecb9'
$checksumfr = '38d92e78d3d200a065f39229d9707f95b594809289c68366fc04ea0e68a07857'
$checksumjp = '82985065f7395fa92fd5e5b8c07a1643d247a6581f9b7187caa9ccc9496778c9'
$checksumzh = '6d1ed0a3920c0c578b703ffc5141d569754fdb668721732f07ffa03a25754c43'
$checksum = 'f10084a5d2bd7f6e1542fc2d56fb9b5c012422d10346d0ecd636030c4337b169'

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
