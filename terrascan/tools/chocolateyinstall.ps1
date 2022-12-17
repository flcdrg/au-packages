$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'terrascan*'
  
  url           = 'https://github.com/tenable/terrascan/releases/download/v1.17.1/terrascan_1.17.1_Windows_i386.zip'
  checksum      = 'b44c7be39ddb117facce002f41f7b483746854182240812104d3243785efede6'
  checksumType  = 'sha256'
  url64bit      = 'https://github.com/tenable/terrascan/releases/download/v1.17.1/terrascan_1.17.1_Windows_x86_64.zip'
  checksum64    = '6a85900813a2663f241207fbc947fa7d94f40ccd10ead67d4f4a71dda6d7bcda'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
