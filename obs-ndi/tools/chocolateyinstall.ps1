$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

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
  checksum      = 'C255860560C86EDFFD77697413EE0ABB33847809E811449F790D1D00A0771CBF'
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