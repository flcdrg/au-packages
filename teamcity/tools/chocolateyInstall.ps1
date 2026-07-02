$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'TeamCity-2025.11.6.tar.gz'
$checksum = '761e5ea29b1acbfeb96e2ac4bbab219db80f4adaf60727b4107a629eb6cad99f'

$url = 'https://download.jetbrains.com/teamcity/TeamCity-2025.11.6.tar.gz'
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
