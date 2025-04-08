$ErrorActionPreference = 'Stop';
$PackageParameters = Get-PackageParameters

$url        = 'https://global.download.synology.com/download/Utility/ActiveBackupBusinessAgent/3.0.0-4631/Windows/i686/Synology%20Active%20Backup%20for%20Business%20Agent-3.0.0-4631-x86.msi'
$url64      = 'https://global.download.synology.com/download/Utility/ActiveBackupBusinessAgent/3.0.0-4631/Windows/x86_64/Synology%20Active%20Backup%20for%20Business%20Agent-3.0.0-4631-x64.msi'
$checksum   = '9db7e6435441b316b52e9861b3170727a8354d1a28a311cf82d072e605b936cb'
$checksum64 = '197e420b7cdeaea70c575d71721fb8ec6f6f2966f1c2f955162b537946d6996e'

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
