$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$ndiChecksum = '93BAED79F27203C61A090093BD4A1BAFBB606C6A8E768D9DEA650AD23B7BDF71'

# DO NOT CHANGE THESE MANUALLY, USE update.ps1
$url      = 'https://github.com/DistroAV/DistroAV/releases/download/6.0.0/distroav-6.0.0-windows-x64-Installer.exe'
$checksum = '9a57af278fbffc348ade7659289ab9cb0a62c7233863bf5a29f6d2949df5f0f1'

# First, install NDI Runtime
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = 'http://ndi.link/NDIRedistV6'
  softwareName  = 'NDI 6 Runtime'
  checksum      = $ndiChecksum
  checksumType  = 'sha256'
  silentArgs    = '/VERYSILENT /LOG /NORESTART /SUPPRESSMSGBOXES'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

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

Write-Warning "You must reboot your computer to make a new or updated NDI Runtime installation effective"
