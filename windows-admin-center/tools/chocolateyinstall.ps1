$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://download.microsoft.com/download/5e854024-dcf1-4e86-9546-7389fd08a34b/WindowsAdminCenter2611.exe'
$checksum = '1EC128F76AB95EC4FE507400FCC37FAAD0E9F34FC1C3D33B6149C72B99D22F60'

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
