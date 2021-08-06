$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url64 = 'https://dl.dell.com/FOLDER06526860M/1/Systems-Management_Application_8CTK7_WN64_1.9.0_A00.EXE'
$checksum64 = '952eb4132ed409a849b9c64570311d60'

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
