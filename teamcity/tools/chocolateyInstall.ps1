$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'TeamCity-2026.1.1.tar.gz'
$checksum = '746506c35ef5f79fb7d1f32995af03e5ee1d09ac7634a29d0a57b9a05c6fb456'

$url = 'https://download.jetbrains.com/teamcity/TeamCity-2026.1.1.tar.gz'
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
