$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$checksum     = '9162573724debef6af0193d291f07da937486a2551994e6395471e9163fbccb3'

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
