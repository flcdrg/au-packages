$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# DO NOT CHANGE THESE MANUALLY, USE update.ps1
$url = 'https://github.com/DistroAV/DistroAV/releases/download/6.2.0/distroav-6.2.0-windows-x64-Installer.exe'
$checksum = 'ac7b951764d359ec44c2a025cfd1c0e6316f1c435fe78a3bc77e2f1408ff5ab6'

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
