$ErrorActionPreference = 'Stop';
$PackageParameters = Get-PackageParameters

$url        = 'https://global.download.synology.com/download/Utility/ActiveBackupBusinessAgent/3.0.0-4638/Windows/i686/Synology%20Active%20Backup%20for%20Business%20Agent-3.0.0-4638-x86.msi'
$url64      = 'https://global.download.synology.com/download/Utility/ActiveBackupBusinessAgent/3.0.0-4638/Windows/x86_64/Synology%20Active%20Backup%20for%20Business%20Agent-3.0.0-4638-x64.msi'
$checksum   = '5547c028ef3b15a8f5aa28a0e4f1b45d136e0687f28c757f692aa15b8a512e40'
$checksum64 = 'bcdb397939ec48b3ff8e92e759026d31d750918f05bc309196198258c989b3e7'

$silentArgs = ""

# https://kb.synology.com/en-global/DSM/tutorial/How_to_set_up_Active_Backup_for_Business_for_mass_deployment

if ($PackageParameters['Address']) {
    $silentArgs += " ADDRESS=" + $PackageParameters['Address']
}

if ($PackageParameters['Username']) {
    $silentArgs += " USERNAME=" + $PackageParameters['Username']
}

if ($PackageParameters['Password']) {
    $silentArgs += " PASSWORD=" + $PackageParameters['Password']
}

if ($PackageParameters['ProxyAddress']) {
    $silentArgs += " PROXY_ADDR=" + $PackageParameters['ProxyAddress']
}

if ($PackageParameters['ProxyPort']) {
    $silentArgs += " PROXY_PORT=" + $PackageParameters['ProxyPort']
}

if ($PackageParameters['ProxyUsername']) {
    $silentArgs += " PROXY_USERNAME=" + $PackageParameters['ProxyUsername']
}

if ($PackageParameters['ProxyPassword']) {
    $silentArgs += " PROXY_PASSWORD=" + $PackageParameters['ProxyPassword']
}

if ($PackageParameters.RemoveShortcut) {
    $silentArgs += " NO_SHORTCUT=1"
}

if ($PackageParameters['ALLOW_UNTRUST']) {
    $silentArgs += " ALLOW_UNTRUST=1"
}

Write-Output $silentArgs

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'msi'
    url            = $url
    url64          = $url64
    checksum       = $checksum
    checksumType   = 'SHA256'
    checksum64     = $checksum64
    checksumType64 = 'SHA256'
    silentArgs     = "$($silentArgs) /qn"
    ValidExitCodes = @(0, 1000, 1101)
}

Install-ChocolateyPackage @packageArgs
