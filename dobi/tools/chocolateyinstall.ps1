$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://github.com/dnephin/dobi/releases/download/v0.14.0/dobi-windows.exe'
$checksum = '90b02de565936155bb03affa29a4e2fb9470f86adb5641f4805411db751a05d8'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  FileFullPath  = "$toolsDir\dobi.exe"
  url           = $url
  checksum      = $checksum
  checksumType  = 'sha256'
}

Get-ChocolateyWebFile @packageArgs
