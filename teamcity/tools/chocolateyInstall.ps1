$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = "TeamCity-$($env:ChocolateyPackageVersion).tar.gz"
$checksum = '49aa4c5ab088d7a79078204e77a391c8ded1160dda435da5133734d802a576ab'

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
