$ErrorActionPreference = 'Stop';
$PackageParameters = Get-PackageParameters

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
    url            = "https://global.download.synology.com/download/Utility/ActiveBackupBusinessAgent/2.2.0-2070/Windows/i686/Synology%20Active%20Backup%20for%20Business%20Agent-2.2.0-2070-x86.msi"
    url64          = "https://global.download.synology.com/download/Utility/ActiveBackupBusinessAgent/2.2.0-2070/Windows/x86_64/Synology%20Active%20Backup%20for%20Business%20Agent-2.2.0-2070-x64.msi"
    checksum       = "33C52D4C5C8F55099CA56395F73C3050B3571ED0F5F390E4AE49687DBDB1CF298F7F28FE5FE77D99FF3AC30045F6DCFC4678BDB97F288508D8D6576E495C16A5"
    checksumType   = 'SHA512'
    checksum64     = "AA95FBBE1CDFB70424109115F23E2A73485F28A481543ABB3C0251B49848A0D6A8540B3F604ED358C59C93DE8C7E4520AD9630E000EFAC8A2489BB3EC5D3F6C6"
    checksumType64 = 'SHA512'
    silentArgs     = "$($silentArgs) /qn"
    ValidExitCodes = @(0, 1000, 1101)
}

Install-ChocolateyPackage @packageArgs
