$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'NDI 6 Runtime'
  fileType       = 'exe'
  silentArgs     = "/VERYSILENT /LOG /NORESTART /SUPPRESSMSGBOXES"
  
  validExitCodes = @(0)
  url            = "http://ndi.link/NDIRedistV6"
  checksum       = '42C99EDC08272224F9D59C1D9063B8F19EFF40E30FE5EB00657E1BCEB9F73AFF'
  checksumType   = 'sha256'
  destination    = $toolsDir
}

Install-ChocolateyPackage @packageArgs

Write-Warning "You must reboot your computer to make a new or updated NDI Runtime installation effective"
