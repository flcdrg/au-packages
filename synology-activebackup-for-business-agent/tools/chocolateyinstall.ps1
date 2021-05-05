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
    url            = "https://global.download.synology.com/download/Tools/ActiveBackupBusinessAgent/2.1.1-1125/Windows/i686/Synology%20Active%20Backup%20for%20Business%20Agent-2.1.1-1125-x86.msi"
    url64          = "https://global.download.synology.com/download/Tools/ActiveBackupBusinessAgent/2.1.1-1125/Windows/x86_64/Synology%20Active%20Backup%20for%20Business%20Agent-2.1.1-1125-x64.msi"
    checksum       = "DAC9DBA09FA2D06A0D9B9DF15B5AA58D8CB112041148677EC7069B16D4423B30031A77C984B81551FEB71F362DFDC34653EA9B9673678350E161830564C8FCA9"
    checksumType   = 'SHA512'
    checksum64     = "1459A3458BB71262765446040A1DC228808FCF176C1794ED33D6681114454ED7C3CC8687B09AA9810F053F59FF3151B88EA98BA87F0FD24D62D1BAE3484499DA"
    checksumType64 = 'SHA512'
    silentArgs     = "$($silentArgs) /qn"
    ValidExitCodes = @(0, 1000, 1101)
}

Install-ChocolateyPackage @packageArgs
