$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'TeamCity-2024.12.tar.gz'
$checksum = '49b67b7f8ef04b7381816bb5929202f46575f1c74b16e4c5726a156893e20021'

$url = 'https://download.jetbrains.com/teamcity/TeamCity-2024.12.tar.gz'
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
