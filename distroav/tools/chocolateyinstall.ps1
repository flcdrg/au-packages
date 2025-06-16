$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# DO NOT CHANGE THESE MANUALLY, USE update.ps1
$url      = 'https://github.com/DistroAV/DistroAV/releases/download/6.1.1/distroav-6.1.1-windows-x64-Installer.exe'
$checksum = ''


# Now install obs-ndi
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url
  softwareName  = 'obs-ndi*'
  checksum      = $checksum
  checksumType  = 'sha256'
  silentArgs    = '/VERYSILENT /LOG /NORESTART /SUPPRESSMSGBOXES'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
