$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'terrascan*'
  
  url           = 'https://github.com/tenable/terrascan/releases/download/v1.19.9/terrascan_1.19.9_Windows_i386.zip'
  checksum      = 'aa546c8b45c9154a7ff1b000d5164558a1bbf77cff00ae4f2eb8991c4c04cad2'
  checksumType  = 'sha256'
  url64bit      = 'https://github.com/tenable/terrascan/releases/download/v1.19.9/terrascan_1.19.9_Windows_x86_64.zip'
  checksum64    = '2585e0ae7121bfa28a471175ec3cabe810680fcbeb064eefab93a8c6c475b094'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
