$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://downloads.dell.com/FOLDER07582904M/1/Dell-Update-Application-for-Windows-10_KW3CF_WIN_4.3.0_A00.EXE'
$checksum = '5b166a245cbbc4b570a3dce8f1fddc6a'

 # the /factoryinstall parameter makes installer return success instead of '2' (which Chocolatey doesn't like)
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Dell Command | Update for Windows 10'
  fileType      = 'exe'
  silentArgs    = "/s /factoryinstall"
  validExitCodes= @(0)
  url           = $url
  checksum      = $checksum
  checksumType  = 'md5'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs 
