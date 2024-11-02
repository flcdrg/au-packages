$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url64 = 'https://github.com/pbi-tools/pbi-tools/releases/download/1.1.1/pbi-tools.1.1.1.zip'
$checksum64 = 'f2d0a26f68f9ac20a8729513dad850cf9253182c86637209bd49e6753cfe2a77'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'pbi-tools*'
  fileType      = 'zip'
  silentArgs   = ''

  validExitCodes= @(0)
  url64           = $url64
  checksum64      = $checksum64
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
