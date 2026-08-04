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
$version = '5.2.5.32528'

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

$checksumde = '49e9bcbcd3a4d1bf130430bfe1b56e2690e0f7f0aecd130b6be8211f3963bfe3'
$checksumfr = '25afaea871fd722fcc74886b14bbc163df96443bcf9aa98744e37e0d07311f0a'
$checksumjp = 'd0428bbf82bf98b0216c7f5b4737347f88d843463c1a69bc3dc2b55ef46cc513'
$checksumzh = '17df5d281a96e3657fe40a4031b8b4d086b0021328813529a486a3a65ce2f8b5'
$checksum = '968634587b5e1f31d439cf83d86a0b6ad105e294765c4d8e84248299ebd1dcbc'

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
