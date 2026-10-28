$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$urlBase = "https://www.scootersoftware.com/files"

$pp = Get-PackageParameters

if ($pp["LCID"]) {
    $LCID = $pp["LCID"]
}
else {
    $LCID = (Get-UICulture).LCID
}

$german = @(3079, 1031, 5127, 4103, 2055)
$french = @(2060, 11276, 3084, 9228, 12300, 1036, 5132, 13324, 6156, 14348, 10252, 4108, 7180)
$japanese = @(17, 1041)
$chinese = @(2052)
$version = '5.2.7.32913'

# Install for all users by default
if ($pp["CurrentUser"]) {
    $installMode = "/CURRENTUSER"
}
else {
    $installMode = "/ALLUSERS"
}

$packageArgs = @{
    packageName  = 'beyondcompare'
    fileType     = 'exe'
    url          = '' # this gets set below
    silentArgs   = "/SP- /VERYSILENT /NORESTART $InstallMode"
    checksum     = '' # this gets set below
    checksumType = 'sha256'
}

$checksumde = 'd66536602f39fe60ae0c963368539e52644debe30d21cd89ffc215a45bf8c337'
$checksumfr = '7a67065587b449a3982ab69e4b4030374b7902d70a1d2bb07bc9ceb908e34b3a'
$checksumjp = '0acfc2280001097dc0ea057b408e48dd8e58c4da2a15593124ffca0b5916cd31'
$checksumzh = '9335650936a75a5337cb303e737fba957e6bc6f4b75f0e8682ee5f8a031318d2'
$checksum = 'f84c7cca85a46455455062badbceb5cd80e02a21d9e07a1506e626bed561899a'

if ($german -contains $LCID) {
    $packageArgs.url = "$urlBase/BCompare-de-$version.exe"
    $packageArgs.checksum = $checksumde
}
elseif ($french -contains $LCID) {
    $packageArgs.url = "$urlBase/BCompare-fr-$version.exe"
    $packageArgs.checksum = $checksumfr
}
elseif ($japanese -contains $LCID) {
    $packageArgs.url = "$urlBase/BCompare-jp-$version.exe"
    $packageArgs.checksum = $checksumjp
}
elseif ($chinese -contains $LCID) {
    $packageArgs.url = "$urlBase/BCompare-zh-$version.exe"
    $packageArgs.checksum = $checksumzh
}
else {
    $packageArgs.url = "$urlBase/BCompare-$version.exe"
    $packageArgs.checksum = $checksum
}

# Download the installer first so we can place the key file alongside it (if provided)
$installerFileName = "BCompareSetup-$($packageArgs.packageName)-$version.exe"
$installerPath = Get-ChocolateyWebFile @packageArgs -FileFullPath (Join-Path $toolsDir $installerFileName)

try {

    if ($pp["LicenseFile"]) {
        $licenseSource = $pp["LicenseFile"]
        if (!(Test-Path $licenseSource)) {
            throw "License file not found: $licenseSource"
        }

        # Copy the license key file next to the installer (must be named 'BC5Key.txt')
        Copy-Item -Path $licenseSource -Destination (Join-Path $toolsDir 'BC5Key.txt') -Force
    }

    Install-ChocolateyInstallPackage @packageArgs -File $installerPath

}
finally {
    # Clean up license key file
    $licenseKeyPath = Join-Path $toolsDir 'BC5Key.txt'
    if (Test-Path $licenseKeyPath) {
        Remove-Item -Path $licenseKeyPath -Force
    }
}
