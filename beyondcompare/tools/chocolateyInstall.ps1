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
$version = '5.2.2.32209'

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

$checksumde = '2b8788efd579b4e1ce0b66a1a6efc161fda8beb4d90d157303edc3ff31881296'
$checksumfr = 'e73049c094ed1836001070b52acbb2865f7f7c762ec2838607beaa72b6f68e63'
$checksumjp = '5e35377a0e8849ebf542488f8b1e49532c49fa2b3178e32bb177779716403b5f'
$checksumzh = '7d7f7dc17ee854ae64bcbc55bc7e2866ba180b305cc14b7499893d28b6db4b96'
$checksum = '11cdb99770d2c8db50c68cf557db4641d1a162bd4362c9b18286ab7a405cf6a1'

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
