$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url64 = 'https://downloads.dell.com/FOLDER13340462M/1/Systems-Management_Application_N2H86_WN64_2.1.2.0_A00.EXE'
$checksum64 = 'd019ee54fada6bf1a8a4d28efd9dc489'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'dell-system-update*'
  fileType      = 'exe'
  silentArgs    = "/s"
  
  validExitCodes= @(0) #please insert other valid exit codes here
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= 'md5'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
