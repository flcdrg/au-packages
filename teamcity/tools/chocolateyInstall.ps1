$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'TeamCity-2025.07.3.tar.gz'
$checksum = 'd0c6d78c1ecd86ee470e026260db99ab70e83fea55d3ad214fab8313c13a1786'

$url = 'https://download.jetbrains.com/teamcity/TeamCity-2025.07.3.tar.gz'
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
