$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/VirusTotal/vt-cli/releases/download/0.14.0/Windows32.zip'
$url64      = 'https://github.com/VirusTotal/vt-cli/releases/download/0.14.0/Windows64.zip'
$checksum   = 'bc99b734e14c1d6769bf819ade6f701e3d1f70c6c755ca7c4369ab77ddb25c41'
$checksum64 = 'b8e493ee226f832a48b688d63df8ead00eac9aa11266f97d5f8fcd67db44efad'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url
  url64bit      = $url64
  softwareName  = 'vt-cli*'
  checksum      = $checksum
  checksumType  = 'sha256'
  checksum64    = $checksum64
  checksumType64= 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
