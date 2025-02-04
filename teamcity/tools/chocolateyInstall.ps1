$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'TeamCity-2024.12.2.tar.gz'
$checksum = 'ea6341fa0b5376f0384322e47dbed0a412aff8f8c690ca0528ab63642f8c4db8'

$url = 'https://download.jetbrains.com/teamcity/TeamCity-2024.12.2.tar.gz'
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
