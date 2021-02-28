$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://github.com/dnephin/dobi/releases/download/v0.15.0/dobi-windows.exe'
$checksum = 'b2c1d1e580cca5d4bd5e9209a9ed6ec2c9fb079fb03835d515e226b5d76915a3'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  FileFullPath  = "$toolsDir\dobi.exe"
  url           = $url
  checksum      = $checksum
  checksumType  = 'sha256'
}

Get-ChocolateyWebFile @packageArgs
