$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'TeamCity-2023.05.2.tar.gz'
$checksum = '5f30bd106d323ae333d3c7d35b5530a47a68c0fdbaaa7bca6e4d4b71b3fc5e38'

$url = 'https://download.jetbrains.com/teamcity/TeamCity-2023.05.2.tar.gz'
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
