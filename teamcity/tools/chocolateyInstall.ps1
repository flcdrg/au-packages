$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'TeamCity-2026.1.6.tar.gz'
$checksum = '26c5fb3d84fe25d46b0295f6446e3f30b47cdfb1422dc41c04f5eb38e4262519'

$url = 'https://download.jetbrains.com/teamcity/TeamCity-2026.1.6.tar.gz'
$packagePath = $(Split-Path -parent $toolsDir)
$installPath = Join-Path $packagePath $filename

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileFullPath  = $installPath
  url           = $url
  checksum      = $checksum
  checksumType  = 'sha256'
}

Get-ChocolateyWebFile @packageArgs
