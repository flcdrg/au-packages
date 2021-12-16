$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://download.microsoft.com/download/1/0/5/1059800B-F375-451C-B37E-758FFC7C8C8B/WindowsAdminCenter2110.msi'
$checksum = '5EC8842147FF2CFCEE8638CF69165410F0D275F7859D115992AFED75E873F9B7'

$pp = Get-PackageParameters

# Defaults
if ($pp['PORT']) {
  $port = $pp['PORT']
}
else {
  $port = 6516
}

if ($pp['THUMBPRINT']) {
  $certificateOption = 'installed'
}
else {
  $certificateOption = 'generate'
}

$arguments = '/qn /norestart'
$arguments += ' SME_PORT={0}' -f $port
$arguments += ' SSL_CERTIFICATE_OPTION={0}' -f $certificateOption

if ($pp['THUMBPRINT']) {
  $arguments += ' SME_THUMBPRINT={0}' -f $pp['THUMBPRINT']
}

if ($pp['DISABLERESTARTWINRM']) {
  $arguments += ' RESTART_WINRM=0'
}

$arguments += ' /l*v "{0}\{1}.{2}.MsiInstall.log"' -f $env:Temp, $packageName, $env:chocolateyPackageVersion

# http://aka.ms/WACDownload
$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'Windows Admin Center'
  fileType       = 'msi'
  silentArgs     = $arguments
  validExitCodes = @(0, 3010, 1641)
  url            = $url
  checksum       = $checksum
  checksumType   = 'sha256'
  destination    = $toolsDir
}

Install-ChocolateyPackage @packageArgs
