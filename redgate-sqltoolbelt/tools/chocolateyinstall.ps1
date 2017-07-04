$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'exe'
  silentArgs    = "/IAgreeToTheEula"
  
  validExitCodes= @(0)
  url           = "https://download.red-gate.com/SQLToolbelt.exe"
  checksum      = 'A7DA6A6C96AE83C5EA392903A146D5840EFD6136DE311E73AFED0E2F6C81BACC'
  checksumType  = 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs