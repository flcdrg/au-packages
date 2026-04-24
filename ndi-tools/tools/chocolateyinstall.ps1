$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# DO NOT CHANGE THESE MANUALLY, USE update.ps1
$url = 'https://downloads.ndi.tv/Tools/NDI%206%20Tools.exe'
$checksum = '605CB6128999778B38126FFEF167C76D3D8648D39A582FFC71529DD26F64BF32'

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
