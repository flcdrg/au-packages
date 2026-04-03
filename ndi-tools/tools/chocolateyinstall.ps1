$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# DO NOT CHANGE THESE MANUALLY, USE update.ps1
$url = 'https://downloads.ndi.tv/Tools/NDI%206%20Tools.exe'
$checksum = '5B7BCA109A9E16EE58F013F1FB0FCC7E2F03E603B436446FBC356E1D7F51D6BC'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'EXE'
  url            = $url
  softwareName   = 'NDI 6 Tools*'
  checksum       = $checksum
  checksumType   = 'sha256'
  silentArgs     = '/VERYSILENT /LOG /NORESTART /SUPPRESSMSGBOXES'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
