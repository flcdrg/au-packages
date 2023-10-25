$ErrorActionPreference = 'Stop';
$PackageParameters = Get-PackageParameters

$url        = 'https://global.download.synology.com/download/Utility/ActiveBackupBusinessAgent/2.6.2-3080/Windows/i686/Synology%20Active%20Backup%20for%20Business%20Agent-2.6.2-3080-x86.msi'
$url64      = 'https://global.download.synology.com/download/Utility/ActiveBackupBusinessAgent/2.6.2-3080/Windows/x86_64/Synology%20Active%20Backup%20for%20Business%20Agent-2.6.2-3080-x64.msi'
$checksum   = 'b63d45a18ac60d17b79cca2bd145ff6894ddc7c2570068b87b5e3ef9a3fc799e'
$checksum64 = '7936f27e5ffb5c0df15cb97e7ea3d0184c4717703f3f60655414a032a4e94e6f'

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
