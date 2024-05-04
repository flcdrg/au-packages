$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'TeamCity-2024.03.1.tar.gz'
$checksum = 'bd26bdc86a3a65d3cfbf4428eb7d75465cdb34097b62bfdb72cea55cb03275c7'

$url = 'https://download.jetbrains.com/teamcity/TeamCity-2024.03.1.tar.gz'
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
