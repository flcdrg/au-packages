$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# DO NOT CHANGE THESE MANUALLY, USE update.ps1
$url = 'https://github.com/DistroAV/DistroAV/releases/download/6.2.1/distroav-6.2.1-windows-x64-Installer.exe'
$checksum = 'c4c5e78161996aa56ebd6a7902f8b7564ca33b7110c9f71532e69af0d6a8ea57'

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
