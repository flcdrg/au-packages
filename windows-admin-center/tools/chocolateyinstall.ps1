$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://download.microsoft.com/download/1/0/5/1059800B-F375-451C-B37E-758FFC7C8C8B/WindowsAdminCenter2410.exe'
$checksum = '5FA1B293E99B9DCAD020A092B9FFD5D4E5DE1D4C314F8FA121BED717C128B7AF'

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
