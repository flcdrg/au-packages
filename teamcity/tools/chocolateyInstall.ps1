$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = "TeamCity-$($env:ChocolateyPackageVersion).tar.gz"
$checksum = 'fede2da6784af51965d4da8087e7fa4cec3e408457957f4e6a3f842336ae2c4f'

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
