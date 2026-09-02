$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://download.microsoft.com/download/5e854024-dcf1-4e86-9546-7389fd08a34b/WindowsAdminCenter2606.exe'
$checksum = '870C3230B86BE591970912E242788ECF5C93B0974CDB22153B466E73A6941FE8'

$arguments = '/VERYSILENT /NORESTART'
$arguments += ' /LOG="{0}\{1}.{2}.Install.log"' -f $env:Temp, $env:ChocolateyPackageName, $env:chocolateyPackageVersion

# http://aka.ms/WACDownload
$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'Windows Admin Center'
  fileType       = 'exe'
  silentArgs     = $arguments
  validExitCodes = @(0, 3010, 1641)
  url            = $url
  checksum       = $checksum
  checksumType   = 'sha256'
  destination    = $toolsDir
}

Install-ChocolateyPackage @packageArgs
