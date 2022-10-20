$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'terrascan*'
  
  url           = 'https://github.com/tenable/terrascan/releases/download/v1.15.2/terrascan_1.15.2_Windows_i386.zip'
  checksum      = '3553E7600B7AFDDE9729B9BFFFD059218B9EFBBD6B65A4B93BCD021CE10FFEC9'
  checksumType  = 'sha256'
  url64bit      = 'https://github.com/tenable/terrascan/releases/download/v1.15.2/terrascan_1.15.2_Windows_x86_64.zip'
  checksum64    = '686BDD4A5A6614910EEA55911920F59B438EC9DFD72020EB95389DD572F4CC9E'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
