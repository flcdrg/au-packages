$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'pbi-tools*'
  fileType      = 'zip'
  silentArgs   = ''

  validExitCodes= @(0)
  url64           = "https://github.com/pbi-tools/pbi-tools/releases/download/1.0.0-rc.2/pbi-tools.1.0.0-rc.2.zip"  #download URL, HTTPS preferrred
  checksum64      = '2DA0061A53C17BA1B2840BF89EF58B496F9AAB1355FB09A16094D3E3FFB6E934'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
