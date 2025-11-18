$ErrorActionPreference = 'Stop';
$PackageParameters = Get-PackageParameters

$url        = 'https://global.download.synology.com/download/Utility/ActiveBackupBusinessAgent/3.1.0-4967/Windows/i686/Synology%20Active%20Backup%20for%20Business%20Agent-3.1.0-4967-x86.msi'
$url64      = 'https://global.download.synology.com/download/Utility/ActiveBackupBusinessAgent/3.1.0-4967/Windows/x86_64/Synology%20Active%20Backup%20for%20Business%20Agent-3.1.0-4967-x64.msi'
$checksum   = 'e43b0e3e352bc676ecdb76cee7a1bce4ed082e969e61fc13487652829d179939'
$checksum64 = '0d7fd228ebb6f442c52900fc8c1ec4e6e4a907d10c70a8933b9e2c280bd0cccc'

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
