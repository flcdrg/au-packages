$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url64 = 'https://downloads.dell.com/FOLDER14247161M/1/Systems-Management_Application_FKR69_WN64_2.2.1.0_A00.EXE'
$checksum64 = '9e1bbc15f3589758db60da4963eab1bb'

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
