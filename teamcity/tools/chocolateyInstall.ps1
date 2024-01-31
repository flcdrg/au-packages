$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'TeamCity-2023.11.3.tar.gz'
$checksum = 'd865e10fa9f9c36926bf4dc910a78eca70ed759cec58d7010dc8ade43449dfcc'

$url = 'https://download.jetbrains.com/teamcity/TeamCity-2023.11.3.tar.gz'
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
