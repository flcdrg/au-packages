$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# DO NOT CHANGE THESE MANUALLY, USE update.ps1
$url = 'https://github.com/DistroAV/DistroAV/releases/download/6.2.2/distroav-6.2.2-windows-x64-Installer.exe'
$checksum = '86087f8ac1f51886794e2a903e64e36341aca0a463a5278b88b2c760a06a6f7e'

# Now install obs-ndi
$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'EXE'
  url            = $url
  softwareName   = 'obs-ndi*'
  checksum       = $checksum
  checksumType   = 'sha256'
  silentArgs     = '/VERYSILENT /LOG /NORESTART /SUPPRESSMSGBOXES'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
