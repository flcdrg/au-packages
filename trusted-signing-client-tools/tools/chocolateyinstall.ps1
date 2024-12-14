$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Trusted Signing Client Tools'
  fileType      = 'msi'
  silentArgs    = "/q"
  validExitCodes= @(0, 3010, 1641)
  url           = "https://download.microsoft.com/download/6d9cb638-4d5f-438d-9f21-23f0f4405944/TrustedSigningClientTools.msi"  #download URL, HTTPS preferrred
  checksum      = 'B03307E0DFD5E8BF4B234DE91B5AA13DCE16B80AB6EFE80D9A2176F82CAF578A'
  checksumType  = 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs

