$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$checksum     = 'd3fc271ad250f9d82b61f942815072c1cb20336910a8ec112784617c14242e1b'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'PingPlotter*'
  fileType      = 'exe'
  silentArgs    = "/quiet"
  
  validExitCodes= @(0)
  url           = "https://www.pingplotter.com/downloads/pingplotter_install.exe"
  checksum      = $checksum
  checksumType  = 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
