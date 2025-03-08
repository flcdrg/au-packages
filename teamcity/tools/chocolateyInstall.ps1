$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'TeamCity-2024.12.3.tar.gz'
$checksum = '73e37f04c2f7ec827e946f71fd82b85776089e0fb76f34e3d59319f9381a023e'

$url = 'https://download.jetbrains.com/teamcity/TeamCity-2024.12.3.tar.gz'
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
