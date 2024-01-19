$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'TeamCity-2023.11.2.tar.gz'
$checksum = '4cdb2d3aaef0a74841b013bd20d1763e95be7c9e38370cc2382aa1bc6799ff7e'

$url = 'https://download.jetbrains.com/teamcity/TeamCity-2023.11.2.tar.gz'
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
