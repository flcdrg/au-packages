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
$version = '5.2.3.32296'

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

$checksumde = '1d24e5350e96883b7cf7440588dc8ab8aba86dcb831eaf2775ef8274ecc96b0a'
$checksumfr = 'fac044075521df58b69f04665c43a1d3b315980dd8ddfffa772d84465f58bc91'
$checksumjp = '83bf1dcca0706112ebb42589d3a37b4f41b81018785dee22f9583d6992f0ed85'
$checksumzh = 'c9f01662402a0f2d6ab803fa8403e27366f838af50f35b82a2c438badd37b137'
$checksum = 'a74239803aa1a1373735dc092365cca85c726178625aa51821f35aaf42559621'

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
