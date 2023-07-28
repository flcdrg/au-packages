$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'terrascan*'
  
  url           = 'https://github.com/tenable/terrascan/releases/download/v1.18.2/terrascan_1.18.2_Windows_i386.zip'
  checksum      = '24967cd63c0fd7d0ec693a6c568258400a9bde2bcf1a0c18b5a217d6a7aea869'
  checksumType  = 'sha256'
  url64bit      = 'https://github.com/tenable/terrascan/releases/download/v1.18.2/terrascan_1.18.2_Windows_x86_64.zip'
  checksum64    = 'c36cd34b6d2da8c6742d6fd93c357e8903a30d542713b8b9e9870230f5084f98'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
