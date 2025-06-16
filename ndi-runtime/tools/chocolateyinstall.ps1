$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'NDI 6 Runtime'
  fileType       = 'exe'
  silentArgs     = "/VERYSILENT /LOG /NORESTART /SUPPRESSMSGBOXES"
  
  validExitCodes = @(0)
  url            = "http://ndi.link/NDIRedistV6"
  checksum       = '930648B78EA090511B7AF0339145ABCB1B34F6CE4B17021C57BFCFE07FE64B5E'
  checksumType   = 'sha256'
  destination    = $toolsDir
}

Install-ChocolateyPackage @packageArgs

Write-Warning "You must reboot your computer to make a new or updated NDI Runtime installation effective"
