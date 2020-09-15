$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://github.com/dnephin/dobi/releases/download/v0.13.0/dobi-windows.exe'
$checksum = '5B3FD76E8AD1307AECE88EAE1D919B7EDB8E937F4D01EABE56D9B41ABDCD88A2'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  FileFullPath  = "$toolsDir\dobi.exe"
  url           = $url
  checksum      = $checksum
  checksumType  = 'sha256'
}

Get-ChocolateyWebFile @packageArgs