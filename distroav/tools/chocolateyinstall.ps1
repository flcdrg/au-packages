$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# DO NOT CHANGE THESE MANUALLY, USE update.ps1
$url      = 'https://github.com/DistroAV/DistroAV/releases/download/6.0.0/distroav-6.0.0-windows-x64-Installer.exe'
$checksum = '9a57af278fbffc348ade7659289ab9cb0a62c7233863bf5a29f6d2949df5f0f1'


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
