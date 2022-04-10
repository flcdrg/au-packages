$ErrorActionPreference = 'Stop';
$PackageParameters = Get-PackageParameters

$url        = 'https://global.download.synology.com/download/Utility/ActiveBackupBusinessAgent/2.2.0-2074/Windows/i686/Synology%20Active%20Backup%20for%20Business%20Agent-2.2.0-2074-x86.msi'
$url64      = 'https://global.download.synology.com/download/Utility/ActiveBackupBusinessAgent/2.2.0-2074/Windows/x86_64/Synology%20Active%20Backup%20for%20Business%20Agent-2.2.0-2074-x64.msi'
$checksum   = '7A441C1E1A3DD8CC4B5DA17B0B83C4EB68D5946DD8E352FC6CAA63C05939F34C1A5E34741F2A0A51A3F5B4D61156764F43498B4BDE590ED82821D9FCB03D70CA'
$checksum64 = 'A2CB76C35F84A4FAAFFDE26A9F3660278D406127D46C9CB18BD2E1A91A7FF10834F63EA67227038E7CDD65E05F6D01DF107F6EB8FFFF17C2C7718677F4924589'

$silentArgs = ""

# https://www.synology.com/en-us/knowledgebase/DSM/tutorial/Backup/How_to_customize_Active_Backup_for_Business_Agent_installer_for_mass_deployment

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
