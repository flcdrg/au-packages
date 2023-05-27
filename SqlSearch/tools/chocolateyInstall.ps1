$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$checksum = '84C22C2537F98006E4F2D0A58022E3F191BF782257E69016D86849886E6B7024'
$url = 'https://download.red-gate.com/installers/SQL_Search/2023-05-25/SQL_Search.exe'

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
