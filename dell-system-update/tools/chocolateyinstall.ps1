$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'dell-system-update*'
  fileType      = 'exe'
  silentArgs    = "/s"
  
  validExitCodes= @(0) #please insert other valid exit codes here
  url64bit      = "https://dl.dell.com/FOLDER06526860M/1/Systems-Management_Application_8CTK7_WN64_1.9.0_A00.EXE"
  checksum64    = '953BF0740CD0B61A08914281DF958E2D63CCA21ACBB8281D6589C17210CDB16F'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
