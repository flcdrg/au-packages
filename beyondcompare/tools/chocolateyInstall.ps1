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
$version = '5.2.6.32774'

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

$checksumde = 'fdbd4f4a5ff789858aec8fc5ee59f067a423d88998d4d4e88471bd032c9e9cc2'
$checksumfr = '6c6e9067a4068b206ee0bd95185ea29e3d3caa454d4ffead3e366f860dfeab90'
$checksumjp = 'b30adaa11fd568e1cd73671763e32dd03654e35b0789ecaab1e9d3223e71cb5b'
$checksumzh = 'c5439ae1cd8fb02871d990f5bd0b396326e72890b6d78ef9f870dbd1a1242f56'
$checksum = 'a28a1eb43551999e499a8a16af328e0eff1b9a6d45b7dc479682852701b7bb97'

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
