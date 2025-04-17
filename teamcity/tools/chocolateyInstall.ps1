$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'TeamCity-2025.03.1.tar.gz'
$checksum = '20824ad758775243e314569e3219139fe8494eae0d7deb46bf67725ddb732a9b'

$url = 'https://download.jetbrains.com/teamcity/TeamCity-2025.03.1.tar.gz'
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
