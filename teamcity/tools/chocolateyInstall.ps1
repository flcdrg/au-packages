$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'TeamCity-2026.1.5.tar.gz'
$checksum = '9828bea153d39f80147a0a388d5bfb44b38d5ebcdb1fbcfe6fa5dfbcdd68a2b5'

$url = 'https://download.jetbrains.com/teamcity/TeamCity-2026.1.5.tar.gz'
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
