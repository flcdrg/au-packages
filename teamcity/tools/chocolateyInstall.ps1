$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'TeamCity-2024.07.3.tar.gz'
$checksum = '4a4ee6764c42762b93ca3972d437a6c1bcbd82c97af4fd31c024621bf11cf3a3'

$url = 'https://download.jetbrains.com/teamcity/TeamCity-2024.07.3.tar.gz'
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
