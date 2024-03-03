$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$ndiChecksum = 'BC666D409FA6B2D81FF8650A5B92481742F5E895E4994A1A414BAC423CD8448C'

# DO NOT CHANGE THESE MANUALLY, USE update.ps1
$url      = 'https://github.com/obs-ndi/obs-ndi/releases/download/4.13.0/obs-ndi-4.13.0-windows-x64-Installer.exe'
$checksum = '101DC8A7E4E84DCCF2F89D3A56EEB4C18B9FE83EFF54C3A23F2D104B3545E0C5'

# First, install NDI Runtime
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = 'http://ndi.link/NDIRedistV5'
  softwareName  = 'NDI 5 Runtime'
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
