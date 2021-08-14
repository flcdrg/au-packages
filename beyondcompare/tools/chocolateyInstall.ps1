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
$version = '4.4.0.25886'

$packageArgs = @{
  packageName   = 'beyondcompare'
  fileType      = 'exe'
  url           = $url
  silentArgs = '/SP- /VERYSILENT /NORESTART'

  checksum      = ''
  checksumType  = 'sha256'
}

$checksumde = '2c5e0716fe45b7140ca4f7c14bde453673f06efa646197fef940c22534750f0e'
$checksumfr = '4fb732f37099699b7b358ef1e81842e94714a60da63feb6a1180a569cf000c51'
$checksumjp = '0d7506240d3386434c2409f8aa464742a1bdbff039912ad16ece29281f5587a1'
$checksumzh = '3e97d4fc7ec86e9db4575c05ae706560b52ab3ba0a093581cbf45c1420ad54a4'
$checksum = 'e0809545d376323f03893dde9bae6db746de385067baca157b2f506d29d17498'

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
