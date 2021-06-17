$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://dl.dell.com/FOLDER07414802M/1/Dell-Command-Update-Application-for-Windows-10_W1RMW_WIN_4.2.1_A00.EXE'
$checksum = '552d37a1dd5ef06c7af82f8f81f003e9f4b35d6d95ecaf2361c84f43459630f3'

 # the /factoryinstall parameter makes installer return success instead of '2' (which Chocolatey doesn't like)
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Dell Command | Update for Windows 10'
  fileType      = 'exe'
  silentArgs    = "/s /factoryinstall"
  validExitCodes= @(0)
  url           = $url
  checksum      = $checksum
  checksumType  = 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs 
