$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$ndiChecksum = 'BC666D409FA6B2D81FF8650A5B92481742F5E895E4994A1A414BAC423CD8448C'

# DO NOT CHANGE THESE MANUALLY, USE update.ps1
$url      = 'https://github.com/obs-ndi/obs-ndi/releases/download/4.13.1/obs-ndi-4.13.1-windows-x64-Installer.exe'
$checksum = 'a73f34baea9b3739fa501b7311cd00cd24ad243755e6081c24e7996141b671ea'

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
