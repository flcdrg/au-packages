$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'TeamCity-2023.11.1.tar.gz'
$checksum = 'd529ffbbb7f33e669e87f3c525d807a2e0ce8385c679060e20a3cce03d8c2a9f'

$url = 'https://download.jetbrains.com/teamcity/TeamCity-2023.11.1.tar.gz'
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
