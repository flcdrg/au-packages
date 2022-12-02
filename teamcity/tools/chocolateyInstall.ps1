$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = "TeamCity-$($env:ChocolateyPackageVersion).tar.gz"
$checksum = '56ae181972178411ad6501921b488a87df6d6c988c0926f63c72326fda7ec06e'

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
