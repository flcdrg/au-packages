$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = "TeamCity-$($env:ChocolateyPackageVersion).tar.gz"
$checksum = '1648b6429408b0a26d87db80a2b788a49b23c674370cebf65117a8a9d2a0e8ec'

$url = "https://download.jetbrains.com/teamcity/TeamCity-$($env:ChocolateyPackageVersion).tar.gz"
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
