$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$checksum = '172944E80A409D69D631980342928863A5E9EF95D31A96FB8705DF80DADDADE2'
$url = 'https://download.red-gate.com/installers/DotNETDeveloperBundle/2021-09-15/DotNETDeveloperBundle.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'exe'
  silentArgs    = "/IAgreeToTheEULA"
  validExitCodes= @(0)
  url           = $url
  checksum      = $checksum
  checksumType  = 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
