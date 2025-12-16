$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'TeamCity-2025.11.1.tar.gz'
$checksum = '9f51dff36ad64623b6b699525d154b1fbfd3b39564b8c173642480281bd72239'

$url = 'https://download.jetbrains.com/teamcity/TeamCity-2025.11.1.tar.gz'
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
